const { expect } = require("chai");
const { ethers } = require("hardhat");

const supply = 1000000;

describe("Escrow with Fees", function () {

    
    before(async function () {
        this.EscrowWithFees = await ethers.getContractFactory("EscrowWithFees");
        this.ERC20 = await ethers.getContractFactory("ERC20");

       
        [this.buyer, this.seller, this.arbitrator, this.feeRecipient, this.anyone] = 
        await ethers.getSigners();

        this.resetEscrow = async function (_flatFee, _bps){
            /* 
                constructor(
                    address _buyer,
                    address _seller,
                    address _arbitrator,
                    address _feeRecipient,
                    uint256 _flatFee,
                    uint256 _bps,
                    address erc20
                ) 
            */
            this.escrow = await this.EscrowWithFees.deploy(
                this.buyer.address, 
                this.seller.address,
                this.arbitrator.address,
                this.feeRecipient.address,
                _flatFee,
                _bps,
                this.token.address
            );       
            this.escrow = await this.escrow.deployed();

            let tx = await this.token.transfer(this.escrow.address, supply);
            await tx.wait();
            return this.escrow;
    }
    });
    

    beforeEach(async function () {
        this.token = await this.ERC20.deploy(supply);
        await this.token.deployed();
    });

    

    it("When buyer release funds, seller gets price and feeRecipient the fee", async function () {
        let flatFee=100;
        let bps = 50; 
        let amount = 1000;
        let expectedFee = amount * bps/10000 + flatFee;

        console.log(flatFee,bps,supply);
        await this.resetEscrow(flatFee,bps);
        let fromBuyer = await this.escrow.connect(this.buyer);
        let tx = await fromBuyer.release( amount );
        await tx.wait();

        let balance = await this.token.balanceOf(this.escrow.address);
        expect(balance.toString()).to.be.equal(""+(supply - amount - expectedFee));

        let balanceSeller = await this.token.balanceOf(this.seller.address);
        expect(balanceSeller.toString()).to.be.equal((amount)+"");
        expect((await this.token.balanceOf(this.feeRecipient.address)).toString()).to.be.equal(""+expectedFee);

    });

    it("When fee is higher than transaction, fee is deducted correctly from escrow", async function () {
        let flatFee=500;
        let bps = 0; 
        let amount = 400;
        let expectedFee = amount * bps/10000 + flatFee;

        await this.resetEscrow(flatFee,bps);
        let fromBuyer = await this.escrow.connect(this.buyer);
        let tx = await fromBuyer.release( amount );
        await tx.wait();

        let balance = await this.token.balanceOf(this.escrow.address);
        expect(balance.toString()).to.be.equal(""+(supply-amount-expectedFee));
        let balanceSeller = await this.token.balanceOf(this.seller.address);
        
        expect(balanceSeller.toString()).to.be.equal(""+(amount));
        expect((await this.token.balanceOf(this.feeRecipient.address)).toString()).to.be.equal(""+expectedFee);

    });



    it("When fee is higher than escrow balance, transaction fails", async function () {
        let flatFee=supply+1;
        let bps = 0; 
        let amount = 1000;
        await this.resetEscrow(flatFee,bps);
        let fromBuyer = await this.escrow.connect(this.buyer);
        await expect(fromBuyer.release( amount )).to.be.reverted;

    });

});