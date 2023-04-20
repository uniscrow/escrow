pragma solidity 0.8.18;

import "./EscrowTransaction.sol";
import "./FeeCalculator.sol";



contract EscrowWithFees is EscrowTransaction, FeeCalculator{

    constructor(
        address _buyer,
        address _seller,
        address _arbitrator,
        address _feeRecipient,
        uint256 _flatFee,
        uint256 _bps,
        address erc20
    ) 
    EscrowTransaction(_buyer, _seller, _arbitrator, erc20) 
    FeeCalculator(_feeRecipient, _flatFee, _bps){}

    function _transfer(address to, uint256 amount) internal override {
        uint256 fee = calculateFee(amount);
        super._transfer(feeRecipient,fee);
        super._transfer(to, amount );
    }

}