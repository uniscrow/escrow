// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");
const { ethers } = require("hardhat");

async function main() {
	// Hardhat always runs the compile task when running scripts with its command
	// line interface.
	//
	// If this script is run directly using `node` you may want to call compile
	// manually to make sure everything is compiled
	// await hre.run('compile');

	// We get the contract to deploy
	const [deployer] = await ethers.getSigners();
	const accounts = await ethers.getSigners();
	provider = ethers.provider;
	for (const account of accounts) {
		console.log(account.address);
		let balance = await provider.getBalance(account.address);
		console.log(account.address + " " + balance.toString());
	}
	const Factory = await hre.ethers.getContractFactory("Factory");
	const factory = await Factory.deploy();

	console.log("Deploying contracts with the account:", deployer.address);
	await factory.deployed();
	console.log("Factory deployed to:", factory.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
	.then(() => process.exit(0))
	.catch((error) => {
		console.error(error);
		process.exit(1);
	});
// 0x13D292CE789597020e6B4f474b84f7e89d5F994f