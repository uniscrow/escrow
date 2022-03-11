const { expect } = require("chai");
const { ethers } = require("hardhat");

const PENDING  = 0;
const COMPLETE = 1;
describe("WalletFactory", function () {
    before(async function () {
        this.Factory = await ethers.getContractFactory("Factory");
        this.ERC20 = await ethers.getContractFactory("ERC20");
        [this.alice, this.bob, this.charlie, this.arbitrator, this.agent] = await ethers.getSigners();
        //console.log(this.alice.address);
        this.factory = await this.Factory.deploy();
        await this.factory.deployed();
        console.log("factory:"+this.factory.address);
        this.token = await this.ERC20.deploy(100);
        await this.token.deployed();
        console.log("token:"+this.token.address);
    });
    
    it("A new wallet with arbitrator is created", async function () {
        
        await expect(this.factory
            .createArbitrated(
                            this.alice.address,
                            this.bob.address,
                            this.arbitrator.address,
                            this.token.address))
            .to
            .emit(this.factory,"NewWallet");
            //.withArgs();
    });

    it("A new wallet with managing agent is created", async function () {
        
        await expect(this.factory
            .createManaged(
                            this.alice.address,
                            this.bob.address,
                            this.agent.address,
                            this.token.address))
            .to
            .emit(this.factory,"NewWallet");
            //.withArgs();
    });
});