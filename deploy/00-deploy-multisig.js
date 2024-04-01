module.exports = async ({ getNamedAccounts, deployments, getChainId, ethers }) => {
    const { deploy, log } = deployments
    const { deployer, owner1, owner2, owner3 } = await getNamedAccounts()

    const required = 2
    const args = [[owner1, owner2, owner3], required]
    await deploy('MultiSig', {
        from: deployer,
        args,
        log: true,
    })
}

module.exports.tags = ['all', 'multisig']


