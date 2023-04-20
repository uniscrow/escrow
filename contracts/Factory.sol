pragma solidity 0.8.18;
import "./PresetManagedWithFees.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract Factory is Ownable {
    address public immutable arbitrator;
    address public immutable erc20;
    address public immutable feeRecipient;
    

    event EscrowCreated(address);

    constructor(
        address _arbitrator, 
        address _erc20,
        address _feeRecipient){
            require(_arbitrator != address(0), "Invalid arbitrator address");
            require(_erc20 != address(0), "Invalid ERC20 address");
            require(_feeRecipient != address(0), "Invalid feeRecipient address");
            arbitrator = _arbitrator;
            erc20 = _erc20;
            feeRecipient = _feeRecipient;

    }

    function createEscrow(
        address seller, 
        address buyer, 
        uint256 flatFee, 
        uint256 bpsFee,
        uint256 allowance ) external onlyOwner {

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
