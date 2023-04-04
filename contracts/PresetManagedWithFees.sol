pragma solidity >=0.8 <0.9.0;

import "./EscrowWithFees.sol";
import "./Managed.sol";

contract PresetManagedWithFees is EscrowWithFees,Managed {
        constructor(
        address _buyer,
        address _seller,
        address _arbitrator,
        address _feeRecipient,
        uint256 _flatFee,
        uint256 _bps,
        address erc20,
        uint256 allowance
    ) EscrowWithFees(
        _buyer,
        _seller, 
        _arbitrator,
        _feeRecipient,
        _flatFee,
        _bps, 
        erc20)
    Managed( _arbitrator, erc20, allowance){}
}