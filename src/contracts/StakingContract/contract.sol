
// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";

contract StakingContract is Ownable {
    using SafeERC20 for IERC20;

    IERC20 public stakingToken;
    uint256 public rewardRate; // Tokens per second
    uint256 public totalStaked;

    mapping(address => uint256) public stakedBalance;
    mapping(address => uint256) public lastUpdateTime;
    mapping(address => uint256) public rewards;

    event Staked(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event RewardsClaimed(address indexed user, uint256 amount);

    constructor() Ownable() {
        stakingToken = IERC20(address(0x1234567890123456789012345678901234567890)); // Replace with actual token address
        rewardRate = 1e18; // 1 token per second, adjust as needed
    }

    function stake(uint256 amount) external {
        require(amount > 0, "Cannot stake 0");
        updateReward(msg.sender);
        stakedBalance[msg.sender] += amount;
        totalStaked += amount;
        stakingToken.safeTransferFrom(msg.sender, address(this), amount);
        emit Staked(msg.sender, amount);
    }

    function withdraw(uint256 amount) external {
        require(amount > 0, "Cannot withdraw 0");
        require(stakedBalance[msg.sender] >= amount, "Not enough staked balance");
        updateReward(msg.sender);
        stakedBalance[msg.sender] -= amount;
        totalStaked -= amount;
        stakingToken.safeTransfer(msg.sender, amount);
        emit Withdrawn(msg.sender, amount);
    }

    function claimRewards() external {
        updateReward(msg.sender);
        uint256 reward = rewards[msg.sender];
        if (reward > 0) {
            rewards[msg.sender] = 0;
            stakingToken.safeTransfer(msg.sender, reward);
            emit RewardsClaimed(msg.sender, reward);
        }
    }

    function getStakedBalance(address account) external view returns (uint256) {
        return stakedBalance[account];
    }

    function getRewards(address account) external view returns (uint256) {
        return rewards[account] + calculateRewards(account);
    }

    function updateReward(address account) internal {
        rewards[account] += calculateRewards(account);
        lastUpdateTime[account] = block.timestamp;
    }

    function calculateRewards(address account) internal view returns (uint256) {
        uint256 timeElapsed = block.timestamp - lastUpdateTime[account];
        return (stakedBalance[account] * timeElapsed * rewardRate) / 1e18;
    }

    function setRewardRate(uint256 newRate) external onlyOwner {
        rewardRate = newRate;
    }

    function recoverERC20(address tokenAddress, uint256 tokenAmount) external onlyOwner {
        require(tokenAddress != address(stakingToken), "Cannot withdraw staking token");
        IERC20(tokenAddress).safeTransfer(owner(), tokenAmount);
    }
}
