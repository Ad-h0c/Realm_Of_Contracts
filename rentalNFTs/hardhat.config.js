/** @type import('hardhat/config').HardhatUserConfig */
require("dotenv").config();
require("@nomicfoundation/hardhat-chai-matchers");
require("@nomicfoundation/hardhat-toolbox");
require("@nomiclabs/hardhat-ethers");

const { ALCHEMY_API_KEY, GOERLI_PRIVATE_KEY, YOUR_ETHERSCAN_API_KEY } =
  process.env;

module.exports = {
  solidity: "0.8.9",
  networks: {
    goerli: {
      url: `https://eth-goerli.alchemyapi.io/v2/${ALCHEMY_API_KEY}`,
      accounts: [GOERLI_PRIVATE_KEY],
    },
  },
  etherscan: {
    // Your API key for Etherscan
    // Obtain one at https://etherscan.io/
    apiKey: YOUR_ETHERSCAN_API_KEY,
  },
};
