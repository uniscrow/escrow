pragma solidity 0.8.18;

import "./EscrowWithFees.sol";
import "./Managed.sol";

/**
 * @title PresetManagedWithFees contract that combines EscrowWithFees and Managed contracts.
 * @author Davide Carboni

 * @dev This contract inherits from both EscrowWithFees and Managed contracts.
 */
contract PresetManagedWithFees is EscrowWithFees, Managed {
    /**
     * @notice Creates a new PresetManagedWithFees contract.
     * @param _buyer The address of the buyer in the escrow contract.
     * @param _seller The address of the seller in the escrow contract.
     * @param _arbitrator The address of the arbitrator.
     * @param _feeRecipient The address of the recipient of the escrow fees.
     * @param _flatFee The flat fee amount to be paid to the fee recipient.
     * @param _bps The fee amount in basis points to be paid to the fee recipient.
     * @param erc20 The address of the ERC20 token used for payments.
     * @param allowance The maximum amount of tokens that the agent is allowed to spend.
     */
    constructor(
        address _buyer,
        address _seller,
        address _arbitrator,
        address _feeRecipient,
        uint256 _flatFee,
        uint256 _bps,
        address erc20,
        uint256 allowance
    )
        EscrowWithFees(
            _buyer,
            _seller,
            _arbitrator,
            _feeRecipient,
            _flatFee,
            _bps,
            erc20
        )
        Managed(_arbitrator, erc20, allowance)
    {}
}
