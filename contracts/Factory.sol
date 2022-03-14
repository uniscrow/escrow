pragma solidity >=0.8 <0.9.0;

import "./JointWalletArbitrated.sol";
import "./JointWalletManaged.sol";

contract Factory{
    event NewWallet(address);
    mapping(string => address) public contracts2out3Backup;
    mapping(string => address) public contracts2out3Managed;

                            
    function createArbitrated(
                            string memory requestId,
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
        contracts2out3Backup[requestId] = address(wallet);
        emit NewWallet(address(wallet));
    }

    function createManaged(
                            string memory requestId,
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
        contracts2out3Managed[requestId] = address(wallet);
        emit NewWallet(address(wallet));

    }    
}