import React from 'react';

const Hero: React.FC = () => {
  
  return (
    <div className="bg-black py-16 text-white w-full h-full">
      <div className="container mx-auto px-4 flex flex-col md:flex-row items-center h-full">
        <div className="md:w-1/2 mb-8 md:mb-0">
          <h1 className="text-4xl font-bold mb-4">Secure Your Smart Contracts with Confidence</h1>
          <p className="text-xl mb-6">Expert audits to protect your blockchain innovations from vulnerabilities and exploits</p>
        </div>
      </div>
    </div>
  );
};

export { Hero as component }