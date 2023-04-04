pragma solidity >=0.8 <0.9.0;
import "./PresetManagedWithFees.sol";


contract Factory{
    address public arbitrator;
    address public erc20;
    address public feeRecipient;
    uint256 public allowance;
    

    event EscrowCreated(address);

    constructor(
        address _arbitrator, 
        address _erc20,
        address _feeRecipient,
        uint256 _allowance){
            arbitrator = _arbitrator;
            erc20 = _erc20;
            feeRecipient = _feeRecipient;
            allowance = _allowance;
    }

    function createEscrow(
        address seller, 
        address buyer, 
        uint256 flatFee, 
        uint256 bpsFee ) external{

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
