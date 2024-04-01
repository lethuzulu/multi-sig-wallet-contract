require('@nomicfoundation/hardhat-toolbox')
require('dotenv').config()
require('hardhat-deploy')
require('hardhat-deploy-ethers')


module.exports = {
    solidity: '0.8.24',

    namedAccounts: {
        deployer: {
            default: 0,
        },
        owner1: {
            default: 1,
        },
        owner2: {
            default: 2,
        },
        owner3: {
            default: 3,
        },
    },
}
