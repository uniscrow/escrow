const { expect } = require("chai");
const { ethers } = require("hardhat");

const PENDING  = 0;
const COMPLETE = 1;
describe("WalletFactory", function () {
    before(async function () {
        this.Factory = await ethers.getContractFactory("Factory");
        this.ERC20 = await ethers.getContractFactory("ERC20");
        [this.alice, this.bob, this.charlie, this.dave, this.backup] = await ethers.getSigners();
        //console.log(this.alice.address);
        this.factory = await this.Factory.deploy();
        await this.factory.deployed();

    });
    
    it("A new wallet is created", async function () {
        await expect (this.factory
            .create2out3Backup([this.alice,
                            this.bob,
                            this.dave],
                            this.backup,
                            this.ERC20))
            .to
            .emit(this.factory,"NewWallet")
            .withArgs(0);
        

    });
});