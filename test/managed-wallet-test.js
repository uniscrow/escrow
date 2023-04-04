const { expect } = require("chai");
const { ethers } = require("hardhat");

const PENDING  = 0;
const COMPLETE = 1;


//uncomment one of the following to mute/unmute logs
const log = console.log;
//const log = x=>{}


describe("Wallet With Delegated Agent", function () {

    
    before(async function () {
        this.Wallet = await ethers.getContractFactory("Managed");
        this.ERC20 = await ethers.getContractFactory("ERC20");
       
        [this.alice, this.agent] = await ethers.getSigners();

        this.token = await this.ERC20.deploy(100);
        await this.token.deployed();
        this.wallet = await this.Wallet.deploy(
            this.agent.address, 
            this.token.address,
            80);//for sake of more cases, we allow agent to spend only 80


        await this.wallet.deployed();
        tx = await this.token.transfer(this.wallet.address, 100);
        await tx.wait();
        log(tx);
        let balance = await this.token.balanceOf(this.wallet.address);
        log('wallet balance',balance.toString());
        expect(balance.toString()).to.equal('100',"must be 100");
    });

    
    it("Agent can move funds", async function () {
        //console.log(this.token.allowance);
        log('allowance', 
        (await this.token.allowance(this.wallet.address,this.agent.address)).toString());
        
        let tokenSeenByAgent = await this.token.connect(this.agent);

        tx = await tokenSeenByAgent.transferFrom(
            this.wallet.address,
            this.alice.address,
            60
        );

        await tx.wait();
        let balance = await this.token.balanceOf(this.wallet.address);
        log('wallet balance',balance.toString());

        //balance of wallet is expected to be 40
        expect(balance).to.be.equal(40);

        //alice has now 60
        expect(await this.token.balanceOf(this.alice.address)).to.be.equal(60);

        //remaining allowance to agent is 20
        expect(await this.token.allowance(this.wallet.address, this.agent.address)).to.be.equal(20);

    });


    
});
