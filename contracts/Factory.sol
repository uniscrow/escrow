pragma solidity 0.8.18;
import "./PresetManagedWithFees.sol";


contract Factory{
    address public arbitrator;
    address public erc20;
    address public feeRecipient;
    

    event EscrowCreated(address);

    constructor(
        address _arbitrator, 
        address _erc20,
        address _feeRecipient){
            arbitrator = _arbitrator;
            erc20 = _erc20;
            feeRecipient = _feeRecipient;

    }

    function createEscrow(
        address seller, 
        address buyer, 
        uint256 flatFee, 
        uint256 bpsFee,
        uint256 allowance ) external{

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
