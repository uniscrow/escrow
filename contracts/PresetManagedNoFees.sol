pragma solidity >=0.8 <0.9.0;

import "./EscrowTransaction.sol";
import "./Managed.sol";

contract PresetManagedNoFees is EscrowTransaction,Managed {
    constructor(
        address _buyer, 
        address _seller, 
        address _arbitrator,
        address erc20,
        uint256 allowance) 
        
        EscrowTransaction(
        _buyer,
        _seller, 
        _arbitrator,
        erc20)

    Managed( _arbitrator, erc20, allowance){}
}