require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-ganache");
let MNEMONICS = require("./secrets.json").mnemonics;
let URL = require("./secrets.json").url;

let rinkebyInfo = require("./rinkeby-secrets.json");
// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
	const accounts = await hre.ethers.getSigners();

	for (const account of accounts) {
		console.log(account.address);
	}
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
	solidity: "0.8.4",
	defaultNetwork: "uniscrow",
	networks: {
		// hardhat: {
		// },
		uniscrow: {
			url: URL,
			accounts: {
				mnemonic: MNEMONICS,
				path: "m/44'/60'/0'/0",
				initialIndex: 0,
				networkId: "10042",
				count: 20,
			},
		},
		rinkeby: {
			url: `${rinkebyInfo.url}`,
			accounts: [`${rinkebyInfo.addressSecret}`],
		},
	},
};
