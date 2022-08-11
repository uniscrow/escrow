pragma solidity >=0.8 <0.9.0;

import "./JointWalletArbitrated.sol";
import "./JointWalletManaged.sol";

contract Factory{
    event NewWallet(address);
    mapping(string => address) public createArbitratedMap;
    mapping(string => address) public createManagedMap;

     function getManagedContractAddress(string memory requestId)
        public
        view
        returns (address)
    {
        return createManagedMap[requestId];
    }                       
     function getArbitratedContractAddress(string memory requestId)
        public
        view
        returns (address)
    {
        return createArbitratedMap[requestId];
    }                       
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
        createArbitratedMap[requestId] = address(wallet);
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
        createManagedMap[requestId] = address(wallet);
        emit NewWallet(address(wallet));

    }    
}