pragma solidity >=0.8 <0.9.0;



import "./ERC20Wallet2out3.sol";


contract ERC20Wallet2out3Backup is ERC20Wallet2out3{
    
    //the backup address is a special owner which can co-sign but cannot
    //receive funds
    address public backup;
    
    constructor(address _alice, address _bob, address _dave, address _backup, address erc20)
    ERC20Wallet2out3(_alice, _bob, _dave, erc20){
        require (_backup != address(0));
        backup = _backup;
    }
    
    
    function confirmTransfer(uint _nonce) external override{
        require(msg.sender == alice || msg.sender == bob || msg.sender == dave || msg.sender == backup, "not an owner");
        require(payouts[_nonce].initiatedBy != msg.sender, "the initiator cannot confirm");
        require(payouts[_nonce].state == State.pending, "incorrect state for payout");
        token.transfer(alice, payouts[_nonce].qtyAlice);
        token.transfer(bob, payouts[_nonce].qtyBob);
        token.transfer(dave, payouts[_nonce].qtyDave);
        payouts[_nonce].state = State.complete;
        payouts[_nonce].cosignedBy = msg.sender;
    }
    
}