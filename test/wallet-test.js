const { expect } = require("chai");
const { ethers } = require("hardhat");

const PENDING  = 0;
const COMPLETE = 1;
describe("Wallet", function () {

    
    before(async function () {
        this.Wallet = await ethers.getContractFactory("JointWallet");
        this.ERC20 = await ethers.getContractFactory("ERC20");
       
        [this.alice, this.bob, this.charlie] = await ethers.getSigners();
        console.log(this.alice.address);
    });
    
    beforeEach(async function () {
        this.token = await this.ERC20.deploy(100);
        await this.token.deployed();
        this.wallet = await this.Wallet.deploy(this.alice.address, this.bob.address,this.token.address);
        await this.wallet.deployed();
        tx = await this.token.transfer(this.wallet.address, 100);
        await tx.wait();
        //console.log(tx);
        let balance = await this.token.balanceOf(this.wallet.address);
        //console.log(balance);
        expect(balance.toString()).to.equal('100',"must be 100");
    });

    it("Alice can command a direct transfer to Bob and vice versa", async function () {
        let amount = 1;


        expect(await this.token.balanceOf(this.bob.address)).to.equal(0);
        let tx = await this.wallet.directTransfer(amount);
        await tx.wait();
        expect(await this.token.balanceOf(this.bob.address)).to.equal(1);

        let walletSeenByBob = await this.wallet.connect(this.bob);
        expect(await this.token.balanceOf(this.alice.address)).to.equal(0);
        tx = await walletSeenByBob.directTransfer(amount + 1);
        await tx.wait();
        expect(await this.token.balanceOf(this.alice.address)).to.equal(2);
    });
    

    it("Nobody other Alice and Bob can command direct transfer", async function () {
        let amount = 1;
        
        let walletSeenByCharlie = await this.wallet.connect(this.charlie);
        await expect(walletSeenByCharlie.directTransfer(amount)).to.be.reverted;

        let walletSeenByDave = await this.wallet.connect(this.dave);
        await expect(walletSeenByDave.directTransfer(amount)).to.be.reverted;
    });

    it("Alice can init a transfer and Bob can confirm", async function () {
        let tx = await this.wallet.initTransfer(2,3);
        await tx.wait();
        let index = await this.wallet.nonce() - 1;
        //console.log(index);
        let payout = (await this.wallet.payouts(index));
        //console.log(payout);
        expect(payout.initiatedBy).to.equal(this.alice.address);
        expect(payout.state).to.equal(PENDING);
        
        
        let walletSeenByBob = await this.wallet.connect(this.bob);
        //console.log("now connected with bob");
        
        tx = await walletSeenByBob.confirmTransfer(index);
        await tx.wait();
        payout = (await this.wallet.payouts(index));
        //console.log(payout);
        expect(payout.state).to.equal(COMPLETE);

        expect(await this.token.balanceOf(this.bob.address)).to.equal(3);
        expect(await this.token.balanceOf(this.alice.address)).to.equal(2);
    });
   
    it("Bob can init a transfer and Alice can confirm", async function () {
        
        let wallet = await this.wallet.connect(this.bob);
        
        let tx = await wallet.initTransfer(2,3);
        await tx.wait();
        let index = await wallet.nonce() - 1;
        //console.log(index);
        let payout = (await wallet.payouts(index));
        //console.log(payout);
        expect(payout.initiatedBy).to.equal(this.bob.address);
        expect(payout.state).to.equal(PENDING);
        
        
        wallet = await this.wallet.connect(this.alice);
        //console.log("now connected with alice");
        
        tx = await wallet.confirmTransfer(index);
        await tx.wait();
        payout = (await this.wallet.payouts(index));
        //console.log(payout);
        expect(payout.state).to.equal(COMPLETE);

        expect(await this.token.balanceOf(this.bob.address)).to.equal(3);
        expect(await this.token.balanceOf(this.alice.address)).to.equal(2);
    });

    it("Events are emitted on transfer and confirm", async function () {
        let index = await this.wallet.nonce();
        
        await expect(this.wallet.initTransfer(2,3))
            .to
            .emit(this.wallet,"TransferInitiated")
            .withArgs(this.alice.address, index);
        
        let walletSeenByBob = await this.wallet.connect(this.bob);
        
        await expect(walletSeenByBob.confirmTransfer(index))
            .to
            .emit(walletSeenByBob,"TransferConfirmed")
            .withArgs(this.bob.address, index);
    });    
    
    it("Alice is owner can init a transfer and charlie (not owner) cannot confirm", async function () {
        let tx = await this.wallet.initTransfer(2,3);
        await tx.wait();
        let index = await this.wallet.nonce() - 1;
        console.log(index);
        let payout = (await this.wallet.payouts(index));
        //console.log(payout);
        expect(payout.initiatedBy).to.equal(this.alice.address);
        expect(payout.state).to.equal(PENDING);
        
        
        let walletSeenByCharlie = await this.wallet.connect(this.charlie);
        console.log("now connected with charlie");
        await expect(walletSeenByCharlie.confirmTransfer(index)).to.be.reverted;
    });
    
    
    it("Charlie is not owner and cannot init a transfer", async function () {
        let walletSeenByCharlie = await this.wallet.connect(this.charlie);
        await expect(walletSeenByCharlie.initTransfer(2,2)).to.be.reverted;
    });    
    
    
    it("Alice can init a transfer but she cannot confirm", async function () {
        let wallet = await this.wallet.connect(this.alice);
        let tx = await wallet.initTransfer(1,1);
        await tx.wait();
        let index = await wallet.nonce() - 1;
        await expect(wallet.confirmTransfer(index)).to.be.reverted;
    });     
    
    it("Bob can init a transfer but he cannot confirm", async function () {
        let wallet = await this.wallet.connect(this.bob);
        let tx = await wallet.initTransfer(1,1);
        await tx.wait();
        let index = await wallet.nonce() - 1;
        await expect(wallet.confirmTransfer(index)).to.be.reverted;
    });      
});
