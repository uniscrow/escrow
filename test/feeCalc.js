const { expect } = require("chai");
const { ethers } = require("hardhat");


describe("Fee Calculator", function () {

    
    before(async function () {
        this.FeeCalculator = await ethers.getContractFactory("FeeCalculator");  
        [this.feeRecipient] = await ethers.getSigners();     
    });
    
    beforeEach(async function () {});

    it("Calculate fees for 1000 with flat = 100 and bps = 25", async function () {
        this.calculator = await this.FeeCalculator.deploy(
            this.feeRecipient.address,
            100,//flat
            25//bps
            );
        
        await this.calculator.deployed();        
        let fee = await this.calculator.calculateFee(1000);
        expect(fee.toString()).to.be.equal("102"); //100 + 5 = 105
    })

    it("Calculate fees for 1000 with flat = 100 and bps = 50", async function () {
        this.calculator = await this.FeeCalculator.deploy(
            this.feeRecipient.address,
            100,//flat
            50//bps
            );
        
        await this.calculator.deployed();        
        let fee = await this.calculator.calculateFee(1000);
        expect(fee.toString()).to.be.equal("105"); //100 + 5 = 105
    })

    it("Calculate fees for 1000 with flat = 0 and bps = 1", async function () {
        this.calculator = await this.FeeCalculator.deploy(
            this.feeRecipient.address,
            0,//flat
            1//bps
            );
        
        await this.calculator.deployed();        
        let fee = await this.calculator.calculateFee(1000);
        expect(fee.toString()).to.be.equal("0"); 
    })

    it("Calculate fees for 10000 with flat = 0 and bps = 100", async function () {
        this.calculator = await this.FeeCalculator.deploy(
            this.feeRecipient.address,
            0,//flat
            100//bps
            );
        
        await this.calculator.deployed();        
        let fee = await this.calculator.calculateFee(10000);
        expect(fee.toString()).to.be.equal("100"); 
    })


});