const { expect } = require("chai");
const { ethers, BigNumber } = require("hardhat");
const ethersReal = require("ethers");

const PENDING = 0;
const COMPLETE = 1;

//uncomment one of the following to mute/unmute logs
//const log = console.log;
const log = (x) => {};

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
		expect(balance.toString()).to.equal("100", "must be 100");
	});

	it("Backup key cannot init a transfer", async function () {
		let walletSeenByBackup = await this.wallet.connect(this.backup);
		await expect(walletSeenByBackup.initTransfer(0, 2, 3)).to.be.reverted;
	});

	it("Backup key can confirm a transfer", async function () {
		let tx = await this.wallet.initTransfer(0, 2, 3);
		await tx.wait();
		let index = (await this.wallet.nonce()) - 1;

		let walletSeenByBackup = await this.wallet.connect(this.backup);
		tx = await walletSeenByBackup.confirmTransfer(index);
		tx.wait();
		payout = await this.wallet.payouts(index);
		log(payout);
		expect(payout.state).to.equal(COMPLETE);
	});

	it("Alice can simulate a initTransfer transaction", async function () {
		let alice2Addr = "0x0d6c6c511a17f2A49f56420622F350dC3e2ee3f1";
		let alice2Mnemonic = "rich lion february sample urban inmate basket book ten bone exhaust first";
		let aliceWallet = ethers.Wallet.fromMnemonic(alice2Mnemonic);

		this.wallet2 = await this.Wallet.deploy(alice2Addr, this.bob.address, this.dave.address, this.backup.address, this.token.address);

		await this.wallet2.deployed();

		tx2 = await this.token.transfer(this.wallet2.address, 100);
		await tx2.wait();
		tx3 = await this.token.transfer(alice2Addr, 100);
		await tx3.wait();
		let alice2 = await this.wallet2.connect(aliceWallet);
        await this.alice.sendTransaction({
            to: alice2Addr,
            value: ethers.utils.parseEther("0.5")
        })

		let tx = await alice2.populateTransaction.initTransfer(1, 2, 3, { gasPrice: ethers.BigNumber.from('10000000')});
		console.log(tx);
		let signedTx = await aliceWallet.signTransaction(tx);
		let gas = await ethers.provider.estimateGas(signedTx);
		console.log(gas.toString());
		let result = await ethers.provider.sendTransaction(signedTx);
        console.log(result);
        let index = await this.wallet2.nonce() - 1;
        let payout = (await this.wallet2.payouts(index));
        expect(payout.initiatedBy).to.equal(alice2Addr);
        expect(payout.state).to.equal(PENDING);
	});
});
