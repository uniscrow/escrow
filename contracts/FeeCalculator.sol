pragma solidity 0.8.18;


contract FeeCalculator{
    //who cashes the fees
    address public immutable feeRecipient;

    //a flat fee, no matter the volume
    uint256 public immutable flatFee;

    // a bp is 1/100 of 1%, also 0.01% or 1/10000
    uint256 public immutable basepoints;

    constructor(address _recipient, uint256  _flat, uint256 _bps){
        require(_recipient != address(0),"Not a valid recipient");
        feeRecipient = _recipient;
        flatFee = _flat;
        basepoints = _bps;
    }

    function calculateFee(uint256 amount) public view returns (uint256) {
        return flatFee + amount * basepoints / 10_000;
    }
    
}