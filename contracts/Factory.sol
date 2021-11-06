pragma solidity >=0.8 <0.9.0;

import "./ERC20Wallet2out3Backup.sol";

contract Factory{
    event NewWallet(address);
    function create2out3Backup(
                            address [3] memory owners, 
                            address backup, 
                            address erc20)  
                            external{
        
        ERC20Wallet2out3Backup wallet =
        new ERC20Wallet2out3Backup( owners[0], 
                                    owners[1], 
                                    owners[2],
                                    backup,
                                    erc20);
        emit NewWallet(address(wallet));

    }
}