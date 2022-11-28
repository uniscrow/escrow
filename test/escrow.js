const { expect } = require("chai");
const { ethers } = require("hardhat");

const supply = 1000000;

describe("Escrow", function () {

    
    before(async function () {
        this.EscrowTransaction = await ethers.getContractFactory("EscrowTransaction");
        this.ERC20 = await ethers.getContractFactory("ERC20");
       
        [this.buyer, this.seller, this.arbitrator, this.anyone] = await ethers.getSigners();
    });
    
    beforeEach(async function () {
        this.token = await this.ERC20.deploy(supply);
        await this.token.deployed();
        this.escrow = await this.EscrowTransaction.deploy(
            this.buyer.address, 
            this.seller.address,
            this.arbitrator.address,
            this.token.address);
        
        await this.escrow.deployed();
        tx = await this.token.transfer(this.escrow.address, supply);
        await tx.wait();
        //console.log(tx);
        let balance = await this.token.balanceOf(this.escrow.address);
        //console.log(balance);
        expect(balance.toString()).to.equal(""+supply);
    });

    it("Buyer can release funds but cannot command refund", async function () {
        let fromBuyer = await this.escrow.connect(this.buyer);
        let tx = await fromBuyer.release( 1 );
        await tx.wait();
        let balance = await this.token.balanceOf(this.escrow.address);
        expect(balance.toString()).to.be.equal(""+(supply-1));
        let balanceSeller = await this.token.balanceOf(this.seller.address);
        expect(balanceSeller.toString()).to.be.equal("1");

        tx = await expect(fromBuyer.refund( 1 )).to.be.reverted;
    });

    it("Seller can refund but cannot command release", async function () {
        let fromSeller = await this.escrow.connect(this.seller);
        let tx = await fromSeller.refund( 1 );
        await tx.wait();
        let balance = await this.token.balanceOf(this.escrow.address);
        expect(balance.toString()).to.be.equal(""+(supply-1));
        let balanceBuyer = await this.token.balanceOf(this.buyer.address);
        expect(balanceBuyer.toString()).to.be.equal("1");

        tx = await expect(fromSeller.release( 1 )).to.be.reverted;

    });

    it("Arbitrator can comand settle, but can't command refund nor release", async function () {
        let fromArbitrator = await this.escrow.connect(this.arbitrator);
        let tx = await fromArbitrator.settle( supply - 10 , 10 );
        await tx.wait();
        let balance = await this.token.balanceOf(this.escrow.address);
        expect(balance.toString()).to.be.equal("0");
        let balanceBuyer = await this.token.balanceOf(this.buyer.address);
        expect(balanceBuyer.toString()).to.be.equal(""+(supply - 10));

        let balanceSeller = await this.token.balanceOf(this.seller.address);
        expect(balanceSeller.toString()).to.be.equal("10");      
        
        tx = await expect(fromArbitrator.release( 1 )).to.be.reverted;
        tx = await expect(fromArbitrator.refund( 1 )).to.be.reverted;
    });

    it("'Anyone' cannot do any action", async function () {
        let fromAnyone = await this.escrow.connect(this.anyone);
        let tx;
        tx = await expect(fromAnyone.settle( supply - 10 , 10 )).to.be.reverted;
        tx = await expect(fromAnyone.refund( 1 )).to.be.reverted;
        tx = await expect(fromAnyone.release( 1 )).to.be.reverted;
    }); 

    

});