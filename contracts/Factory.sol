// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;
import "./PresetManagedWithFees.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title Factory contract for creating escrow contracts.
 * @author Davide Carboni

 */
contract Factory is Ownable {
    /** @notice The address of the arbitrator. */
    address public immutable arbitrator;
    /** @notice The address of the ERC20 token used for payments. */
    address public immutable erc20;
    /** @notice The address of the recipient of the escrow fees. */
    address public immutable feeRecipient;
    
    /**
     * @notice Emitted when a new escrow contract is created.
     * @param escrow The address of the newly created escrow contract.
     */
    event EscrowCreated(address escrow);

    /**
     * @notice Creates a new Factory contract.
     * @param _arbitrator The address of the arbitrator.
     * @param _erc20 The address of the ERC20 token used for payments.
     * @param _feeRecipient The address of the recipient of the escrow fees.
     */
    constructor(
        address _arbitrator, 
        address _erc20,
        address _feeRecipient
    ) {
        require(_arbitrator != address(0), "Invalid arbitrator address");
        require(_erc20 != address(0), "Invalid ERC20 address");
        require(_feeRecipient != address(0), "Invalid feeRecipient address");
        arbitrator = _arbitrator;
        erc20 = _erc20;
        feeRecipient = _feeRecipient;
    }

    /**
     * @notice Creates a new escrow contract with the specified parameters.
     * @dev Only the owner of the Factory contract can call this function.
     * @param seller The address of the seller in the escrow contract.
     * @param buyer The address of the buyer in the escrow contract.
     * @param flatFee The flat fee amount to be paid to the fee recipient.
     * @param bpsFee The fee amount in basis points to be paid to the fee recipient.
     * @param allowance The maximum amount of tokens that the escrow contract is allowed to spend.
     */
    function createEscrow(
        address seller, 
        address buyer, 
        uint256 flatFee, 
        uint256 bpsFee,
        uint256 allowance
    ) external onlyOwner {
        PresetManagedWithFees escrow =
            new PresetManagedWithFees(
                buyer,
                seller,
                arbitrator,
                feeRecipient,
                flatFee,
                bpsFee,
                erc20,
                allowance
        );

        emit EscrowCreated(address(escrow));
    }
}
