// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

/**
 * @title FeeCalculator contract for calculating fees based on flat fee and basis points.
 * @author Davide Carboni

 */
contract FeeCalculator {
    // Who cashes the fees
    address public immutable feeRecipient;

    // A flat fee, no matter the volume
    uint256 public immutable flatFee;

    // A bp is 1/100 of 1%, also 0.01% or 1/10000
    uint256 public immutable basepoints;

    /**
     * @notice Creates a new FeeCalculator contract.
     * @param _recipient The address of the recipient of the fees.
     * @param _flat The flat fee amount to be paid to the fee recipient.
     * @param _bps The fee amount in basis points to be paid to the fee recipient.
     */
    constructor(address _recipient, uint256 _flat, uint256 _bps) {
        require(_recipient != address(0), "Not a valid recipient");
        feeRecipient = _recipient;
        flatFee = _flat;
        basepoints = _bps;
    }

    /**
     * @notice Calculates the fee based on the specified amount.
     * @param amount The amount for which the fee is to be calculated.
     * @return The calculated fee amount.
     */
    function calculateFee(uint256 amount) public view returns (uint256) {
        return flatFee + (amount * basepoints) / 10_000;
    }
}
