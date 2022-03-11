pragma solidity >=0.8 <0.9.0;

import "./JointWalletArbitrated.sol";
import "./JointWalletManaged.sol";

contract Factory{
    event NewWallet(address);
    function createArbitrated(
                            address alice,
                            address bob,
                            address arbitrator, 
                            address erc20)  
                            external{
        
        JointWalletArbitrated wallet =
        new JointWalletArbitrated( alice, 
                                    bob, 
                                    arbitrator,
                                    erc20);
        emit NewWallet(address(wallet));

    }

    function createManaged(
                            address alice,
                            address bob,
                            address agent, 
                            address erc20)  
                            external{
        
        JointWalletManaged wallet =
        new JointWalletManaged( 
                                    alice, 
                                    bob, 
                                    agent,
                                    erc20);
        emit NewWallet(address(wallet));

    }    
}