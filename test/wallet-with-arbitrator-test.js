const { expect } = require("chai");
const { ethers } = require("hardhat");

const PENDING  = 0;
const COMPLETE = 1;





describe("Wallet With arbitrator", function () {

    
    before(async function () {
        this.Wallet = await ethers.getContractFactory("JointWalletArbitrated");
        this.ERC20 = await ethers.getContractFactory("ERC20");   
        [this.alice, this.bob, this.charlie, this.arbitrator] = await ethers.getSigners();
        console.log(this.alice.address);
    });
    
    beforeEach(async function () {
        this.token = await this.ERC20.deploy(100);
        await this.token.deployed();
        this.wallet = await this.Wallet.deploy(this.alice.address, 
                                               this.bob.address, 
                                               this.arbitrator.address, 
                                               this.token.address);
        await this.wallet.deployed();
        tx = await this.token.transfer(this.wallet.address, 100);
        await tx.wait();

        let balance = await this.token.balanceOf(this.wallet.address);
        console.log(balance);
        expect(balance.toString()).to.equal('100',"must be 100");
    });

    
    it("arbitrator key cannot init a transfer", async function () {
        let arbitratorWallet = await this.wallet.connect(this.arbitrator);  
        await expect(arbitratorWallet.initTransfer(2,3)).to.be.reverted;
    });
    
    it("arbitrator can confirm a transfer", async function () {
        let tx = await this.wallet.initTransfer(2,3);
        await tx.wait();
        let index = await this.wallet.nonce() - 1;
        let arbitratorWallet = await this.wallet.connect(this.arbitrator);  
        tx = await arbitratorWallet.confirmTransfer(index);
        tx.wait();
        payout = (await this.wallet.payouts(index));
        console.log(payout);
        expect(payout.state).to.equal(COMPLETE);
    });
    
    
});
