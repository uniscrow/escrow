pragma solidity >=0.8 <0.9.0;

import "./JointWalletArbitrated.sol";

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
  
}