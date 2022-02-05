const { expect } = require("chai");
const { ethers } = require("hardhat");

const PENDING  = 0;
const COMPLETE = 1;
describe("WalletFactory", function () {
    before(async function () {
        this.Factory = await ethers.getContractFactory("Factory");
        this.ERC20 = await ethers.getContractFactory("ERC20");
        [this.alice, this.bob, this.charlie, this.dave, this.backup, this.agent] = await ethers.getSigners();
        //console.log(this.alice.address);
        this.factory = await this.Factory.deploy();
        await this.factory.deployed();
        console.log("factory:"+this.factory.address);
        this.token = await this.ERC20.deploy();
        await this.token.deployed();
        console.log("token:"+this.token.address);
    });
    
    it("A new wallet with backup is created", async function () {
        
        await expect(this.factory
            .create2out3Backup(
                            this.alice.address,
                            this.bob.address,
                            this.dave.address,
                            this.backup.address,
                            this.token.address))
            .to
            .emit(this.factory,"NewWallet");
            //.withArgs();
    });

    it("A new wallet with managing agent is created", async function () {
        
        await expect(this.factory
            .create2out3Managed(
                            this.alice.address,
                            this.bob.address,
                            this.dave.address,
                            this.agent.address,
                            this.token.address))
            .to
            .emit(this.factory,"NewWallet");
            //.withArgs();
    });
});