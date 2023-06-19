# Escrow transactions contracts for erc20 tokens

It implements release, refund and settle with different authorizations levels.
The principle is:

- only the arbitrator can invoke settle
- only the buyer or the arbitrator can invoke release
- only the seller or the arbitrator can invoke refund

The escrow with fees allow for a fee recipient to receive a commission based on volumes and/or flat.



Try running some of the following tasks:

```shell
npx hardhat accounts
npx hardhat compile
npx hardhat clean
npx hardhat test
npx hardhat node
node scripts/sample-script.js
npx hardhat help
```

# Current deployments

At the time of writing there is one factory deployed on Polygon chain with the following address:

0xA7879517eF6DF931f7Fc18058a800ED91a50DDD4

The factory has the following attributes:
- arbitrator safe multisig wallet: 0x3720C6Ae673cFEF5CfbD9a06379530E3BCC8F790
- erc20: 0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174 (the USDC contract in polygon)
- feeRecipient safe multisig wallet: 0x1D1aa7747a4aFb2017BDe15f0318ec6E888c73c1
- owner safe multisig wallet: 0x3720C6Ae673cFEF5CfbD9a06379530E3BCC8F790




