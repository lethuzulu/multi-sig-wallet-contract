const {ethers, getNamedAccounts, deployments, } = require('hardhat')
const {assert, expect} = require('chai')

describe('MultiSig', ()=>{

    let multisigContract, multisigAddress

    let owner1, owner2, owner3

    let deployer

    beforeEach(async ()=>{
        await deployments.fixture(['all'])
        multisigContract = await ethers.getContract('MultiSig')
        multisigAddress = await multisigContract.getAddress()

        deployer = (await getNamedAccounts()).deployer

        owner1 = (await getNamedAccounts()).owner1
        owner2 = (await getNamedAccounts()).owner2
        owner3 = (await getNamedAccounts()).owner3
    })

    describe('constructor', ()=>{
        it('should set owners array and required variable.', async()=>{
            const addresses = Object.values(await getNamedAccounts()).filter((address)=>(address != deployer)) //filter out the deplyer address
            for(i = 0; i < addresses.length; i++){
                    assert.equal(addresses[i], await multisigContract.owners(i))
            }
            assert.equal(2, await multisigContract.signatures())
        })
    })
})