const { expect } = require("chai");
const { ethers } = require("hardhat");

const PENDING  = 0;
const COMPLETE = 1;


//uncomment one of the following to mute/unmute logs
//const log = console.log;
const log = x=>{}


describe("Wallet With Backup", function () {

    
    before(async function () {
        this.Wallet = await ethers.getContractFactory("ERC20Wallet2out3Backup");
        this.ERC20 = await ethers.getContractFactory("ERC20");
       
        [this.alice, this.bob, this.charlie, this.dave, this.backup] = await ethers.getSigners();
        log(this.alice.address);
    });
    
    beforeEach(async function () {
        this.token = await this.ERC20.deploy();
        await this.token.deployed();
        this.wallet = await this.Wallet.deploy(this.alice.address, this.bob.address, this.dave.address, this.backup.address, this.token.address);
        await this.wallet.deployed();
        tx = await this.token.transfer(this.wallet.address, 100);
        await tx.wait();
        log(tx);
        let balance = await this.token.balanceOf(this.wallet.address);
        log(balance);
        expect(balance.toString()).to.equal('100',"must be 100");
    });

    
    it("Backup key cannot init a transfer", async function () {
        let walletSeenByBackup = await this.wallet.connect(this.backup);  
        await expect(walletSeenByBackup.initTransfer(0,2,3)).to.be.reverted;
    });
    
    it("Backup key can confirm a transfer", async function () {
        let tx = await this.wallet.initTransfer(0,2,3);
        await tx.wait();
        let index = await this.wallet.nonce() - 1;
        
        let walletSeenByBackup = await this.wallet.connect(this.backup);  
        tx = await walletSeenByBackup.confirmTransfer(index);
        tx.wait();
        payout = (await this.wallet.payouts(index));
        log(payout);
        expect(payout.state).to.equal(COMPLETE);
    });
    
    
});
