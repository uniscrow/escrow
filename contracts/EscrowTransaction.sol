// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title EscrowTransaction contract for handling escrow transactions.
 * @author Davide Carboni

 */
contract EscrowTransaction {
    using SafeERC20 for IERC20;

    event Released(uint256);
    event Refunded(uint256);
    event Settled(uint256, uint256);

    address public immutable buyer;
    address public immutable seller;
    address public immutable arbitrator;
    address public immutable erc20;

    /**
     * @notice Creates a new EscrowTransaction contract.
     * @param _buyer The address of the buyer in the escrow contract.
     * @param _seller The address of the seller in the escrow contract.
     * @param _arbitrator The address of the arbitrator.
     * @param _erc20 The address of the ERC20 token used for payments.
     */
    constructor(
        address _buyer,
        address _seller,
        address _arbitrator,
        address _erc20
    ) {
        // No address can be null
        require(_buyer != address(0));
        require(_seller != address(0));
        require(_arbitrator != address(0));
        require(_erc20 != address(0));

        buyer = _buyer;
        seller = _seller;
        arbitrator = _arbitrator;
        erc20 = _erc20;
    }

    /**
     * @notice Releases the specified amount to the seller.
     * @dev Can only be called by the buyer or the arbitrator.
     * @param amount The amount to be released.
     */
    function release(uint256 amount) external {
        require(
            msg.sender == buyer || msg.sender == arbitrator,
            "Only buyer or trusted party can release funds"
        );
        _transfer(seller, amount);
        emit Released(amount);
    }

    /**
     * @notice Refunds the specified amount to the buyer.
     * @dev Can only be called by the seller or the arbitrator.
     * @param amount The amount to be refunded.
     */
    function refund(uint256 amount) external {
        require(
            msg.sender == seller || msg.sender == arbitrator,
            "Only seller or trusted party can command a refund"
        );
        _transfer(buyer, amount);
        emit Refunded(amount);
    }

    /**
     * @notice Settles the escrow by refunding and releasing specified amounts.
     * @dev Can only be called by the arbitrator.
     * @param refunded The amount to be refunded to the buyer.
     * @param released The amount to be released to the seller.
     */
    function settle(uint256 refunded, uint256 released) external {
        require(msg.sender == arbitrator, "Only arbitrator can settle");
        _transfer(buyer, refunded);
        _transfer(seller, released);
        emit Settled(refunded, released);
    }

    /**
     * @notice Transfers the specified amount to the recipient.
     * @dev This function is marked as virtual to allow for overrides.
     * @param to The address of the recipient.
     * @param amount The amount to be transferred.
     */
    function _transfer(address to, uint256 amount) internal virtual {
        IERC20 token = IERC20(erc20);
        require(
            amount <= token.balanceOf(address(this)),
            "Insufficient balance"
        );
        token.safeTransfer(to, amount);
    }
}
