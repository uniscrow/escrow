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
