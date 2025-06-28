require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    version: "0.8.26", // This closely matches the Chainlink contracts
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
};
