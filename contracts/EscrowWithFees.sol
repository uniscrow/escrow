// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import "./EscrowTransaction.sol";
import "./FeeCalculator.sol";

/**
 * @title EscrowWithFees contract for handling escrow transactions with fees.
 * @author Davide Carboni

 */
contract EscrowWithFees is EscrowTransaction, FeeCalculator {
    /**
     * @notice Creates a new EscrowWithFees contract.
     * @param _buyer The address of the buyer in the escrow contract.
     * @param _seller The address of the seller in the escrow contract.
     * @param _arbitrator The address of the arbitrator.
     * @param _feeRecipient The address of the recipient of the escrow fees.
     * @param _flatFee The flat fee amount to be paid to the fee recipient.
     * @param _bps The fee amount in basis points to be paid to the fee recipient.
     * @param erc20 The address of the ERC20 token used for payments.
     */
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
    FeeCalculator(_feeRecipient, _flatFee, _bps) {}

    /**
     * @notice Transfers the specified amount to the recipient and deducts the calculated fee.
     * @dev Overrides the _transfer function from the EscrowTransaction contract.
     * @param to The address of the recipient.
     * @param amount The amount to be transferred.
     */
    function _transfer(address to, uint256 amount) internal override {
        uint256 fee = calculateFee(amount);
        super._transfer(feeRecipient, fee);
        super._transfer(to, amount);
    }
}
