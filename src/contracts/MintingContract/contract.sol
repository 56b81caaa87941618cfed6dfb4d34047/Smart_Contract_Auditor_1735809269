
// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract MintingContract is ERC20, Ownable {
    using SafeMath for uint256;

    uint256 private _maxSupply;

    event MaxSupplySet(uint256 newMaxSupply);
    event TokensMinted(address indexed to, uint256 amount);

    constructor() ERC20("MintingToken", "MTK") Ownable() {
        _maxSupply = 1000000 * 10**decimals(); // Default max supply: 1 million tokens
    }

    function mint(address to, uint256 amount) external onlyOwner {
        require(totalSupply().add(amount) <= _maxSupply, "Minting would exceed max supply");
        _mint(to, amount);
        emit TokensMinted(to, amount);
    }

    function setMaxSupply(uint256 newMaxSupply) external onlyOwner {
        require(newMaxSupply >= totalSupply(), "New max supply must be greater than or equal to current total supply");
        _maxSupply = newMaxSupply;
        emit MaxSupplySet(newMaxSupply);
    }

    function getMaxSupply() external view returns (uint256) {
        return _maxSupply;
    }

    function getTotalSupply() external view returns (uint256) {
        return totalSupply();
    }
}
