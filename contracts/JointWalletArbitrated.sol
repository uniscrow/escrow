pragma solidity >=0.8 <0.9.0;



import "./JointWallet.sol";


contract JointWalletArbitrated is JointWallet{
    
    //the arbitrator address is a special owner which can co-sign but cannot
    //receive funds
    address public arbitrator;

    
    constructor(address _alice, address _bob, address _arbitrator, address erc20)
    JointWallet(_alice, _bob, erc20){
        require (_arbitrator != address(0));
        arbitrator = _arbitrator;
    }
    
    
    function confirmTransfer(uint _nonce) external override{
        require(msg.sender == alice || msg.sender == bob || msg.sender == arbitrator, "not an owner");
        require(payouts[_nonce].initiatedBy != msg.sender, "the initiator cannot confirm");
        require(payouts[_nonce].state == State.pending, "incorrect state for payout");

        token.transfer(alice, payouts[_nonce].qtyAlice);
        token.transfer(bob, payouts[_nonce].qtyBob);
        payouts[_nonce].state = State.complete;
        payouts[_nonce].cosignedBy = msg.sender;
    }
    
}