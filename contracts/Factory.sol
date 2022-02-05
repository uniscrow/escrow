pragma solidity >=0.8 <0.9.0;

import "./ERC20Wallet2out3Backup.sol";
import "./ERC20Wallet2out3Managed.sol";

contract Factory{
    event NewWallet(address);
    function create2out3Backup(
                            address alice,
                            address bob,
                            address dave, 
                            address backup, 
                            address erc20)  
                            external{
        
        ERC20Wallet2out3Backup wallet =
        new ERC20Wallet2out3Backup( alice, 
                                    bob, 
                                    dave,
                                    backup,
                                    erc20);
        emit NewWallet(address(wallet));

    }

    function create2out3Managed(
                            address alice,
                            address bob,
                            address dave, 
                            address agent, 
                            address erc20)  
                            external{
        
        ERC20Wallet2out3Managed wallet =
        new ERC20Wallet2out3Managed( 
                                    alice, 
                                    bob, 
                                    dave,
                                    agent,
                                    erc20);
        emit NewWallet(address(wallet));

    }    
}