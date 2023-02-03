require("@nomicfoundation/hardhat-toolbox");
require("hardhat-deploy");
require("solidity-coverage");
require("dotenv").config();

const Goerli_RPC_URL = process.env.GOERLI_RPC_URL;
const Goerli_PRIVATE_KEY = process.env.GOERLI_PRIVATE_KEY;
const LOCAL_RPC_URL = process.env.LOCAL_RPC_URL;
const LOCAL_PRIVATE_KEY = process.env.LOCAL_PRIVATE_KEY;
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY;
const COINMARKETCAP_API_KEY = process.env.COINMARKETCAP_API_KEY;
const LOCAL2_RPC_URL = process.env.LOCAL2_RPC_URL;
const LOCAL2_PRIVATE_KEY = process.env.LOCAL2_PRIVATE_KEY;

module.exports = {
    // solidity: "0.8.8",
    solidity: {
        compilers: [{ version: "0.8.8" }, { version: "0.6.6" }],
    },
    defaultNetwork: "hardhat",
    networks: {
        hardhat: {},
        localhost: {
            url: LOCAL_RPC_URL,
            accounts: [LOCAL_PRIVATE_KEY],
            chainId: 1337,
        },
        localhost2: {
            url: LOCAL2_RPC_URL,
            accounts: [LOCAL2_PRIVATE_KEY],
            chainId: 31337,
        },
        goerli: {
            url: Goerli_RPC_URL,
            accounts: [Goerli_PRIVATE_KEY],
            chainId: 5,
            blockConfirmations: 6,
        },
    },
    gasReporter: {
        enabled: true,
        outputFile: "gas-report.txt",
        noColors: true,
        currency: "USD",
        coinmarketcap: COINMARKETCAP_API_KEY,
        token: "ETH",
    },
    etherscan: {
        apiKey: ETHERSCAN_API_KEY,
    },
    namedAccounts: {
        deployer: {
            default: 0,
        },
    },
};
