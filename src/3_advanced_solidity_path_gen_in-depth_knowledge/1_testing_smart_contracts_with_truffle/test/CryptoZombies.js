const CryptoZombies = artifacts.require("CryptoZombies"); // create contract abstraction (hides the complexity of interacting with Ethereum)
const utils = require("./helpers/utils"); // import library utlis 
const time = require("./helpers/time"); // import library time
var expect = require('chai').expect; // import expect from chai
const zombieNames = ["Zombie 1", "Zombie 2"];

contract("CryptoZombies", (accounts) => {
    let [alice, bob] = accounts; // ganache creates 10 accounts with 100 ETH each
    
    let contractInstance;
    beforeEach(async () => {
        contractInstance = await CryptoZombies.new(); // asyncronous function .new() talks to the blockchain
    });
    
    it("should be able to create a new zombie", async () => { // asynchronous to support await 
        const result = await contractInstance.createRandomZombie(zombieNames[0], {from: alice}); // call to the method
        // assert.equal(result.receipt.status, true); // assert is analogous to require, throws an error in case condition not met
        // assert.equal(result.logs[0].args.name,zombieNames[0]);
        expect(result.receipt.status).to.equal(true); // expect from chai library is used in place of expect
        expect(result.logs[0].args.name).to.equal(zombieNames[0]);
    })

    it("should not allow two zombies", async () => {
        await contractInstance.createRandomZombie(zombieNames[0], {from: alice});
        await utils.shouldThrow(contractInstance.createRandomZombie(zombieNames[1], {from: alice})); // from utils library
      })
    
    context("with the single-step transfer scenario", async () => { // context groups tests (in case xcontext tests are skipped)
        it("should transfer a zombie", async () => {
            const result = await contractInstance.createRandomZombie(zombieNames[0], {from: alice});
            const zombieId = result.logs[0].args.zombieId.toNumber();
            await contractInstance.transferFrom(alice, bob, zombieId, {from: alice});
            const newOwner = await contractInstance.ownerOf(zombieId);
            //assert.equal(newOwner, bob); // check if bob is the new owner
            expect(newOwner).to.equal(bob); 
        })
    })
    
    context("with the two-step transfer scenario", async () => {
        it("should approve and then transfer a zombie when the approved address calls transferFrom", async () => {
            const result = await contractInstance.createRandomZombie(zombieNames[0], {from: alice});
            const zombieId = result.logs[0].args.zombieId.toNumber(); 
            await contractInstance.approve(bob, zombieId, {from: alice});
            await contractInstance.transferFrom(alice, bob, zombieId, {from: bob});
            const newOwner = await contractInstance.ownerOf(zombieId);
            //assert.equal(newOwner,bob);   
            expect(newOwner).to.equal(bob);
        })
        it("should approve and then transfer a zombie when the owner calls transferFrom", async () => {
            const result = await contractInstance.createRandomZombie(zombieNames[0], {from: alice});
            const zombieId = result.logs[0].args.zombieId.toNumber();
            await contractInstance.approve(bob, zombieId, {from: alice});
            await contractInstance.transferFrom(alice, bob, zombieId, {from: alice});
            const newOwner = await contractInstance.ownerOf(zombieId);
            //assert.equal(newOwner,bob);
            expect(newOwner).to.equal(bob);
         })
    })
    
    it("zombies should be able to attack another zombie", async () => {
        let result;
        result = await contractInstance.createRandomZombie(zombieNames[0], {from: alice});
        const firstZombieId = result.logs[0].args.zombieId.toNumber();
        result = await contractInstance.createRandomZombie(zombieNames[1], {from: bob});
        const secondZombieId = result.logs[0].args.zombieId.toNumber();
        await time.increase(time.duration.days(1));
        await contractInstance.attack(firstZombieId, secondZombieId, {from: alice});
        //assert.equal(result.receipt.status, true);
        expect(result.receipt.status).to.equal(true);
    })
})
