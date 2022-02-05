const { expect } = require("chai");
const { ethers } = require("hardhat");

const PENDING  = 0;
const COMPLETE = 1;


//uncomment one of the following to mute/unmute logs
//const log = console.log;
const log = x=>{}


describe("Wallet With Delegated Agent", function () {

    
    before(async function () {
        this.Wallet = await ethers.getContractFactory("ERC20Wallet2out3Managed");
        this.ERC20 = await ethers.getContractFactory("ERC20");
       
        [this.alice, this.bob, this.charlie, this.dave, this.agent] = await ethers.getSigners();
        log(this.alice.address);
    });
    
    beforeEach(async function () {
        this.token = await this.ERC20.deploy(100);
        await this.token.deployed();
        this.wallet = await this.Wallet.deploy(this.alice.address, this.bob.address, this.dave.address, this.agent.address, this.token.address);
        await this.wallet.deployed();
        tx = await this.token.transfer(this.wallet.address, 100);
        await tx.wait();
        log(tx);
        let balance = await this.token.balanceOf(this.wallet.address);
        log(balance);
        expect(balance.toString()).to.equal('100',"must be 100");
    });

    
    it("Either Alice or Bob can dismiss agent", async function () {
        console.log(this.token.allowance);
        console.log(await this.token.allowance(this.wallet.address,this.agent.address));
        tx = await this.wallet.dismissAgent();
        await tx.wait();
        expect(await this.token.allowance(this.wallet.address,this.agent.address)).to.be.equal(0);

    
    });


    
});
