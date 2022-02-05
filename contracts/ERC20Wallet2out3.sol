pragma solidity >=0.8 <0.9.0;


interface IERC20 {

    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount ) external returns (bool);
}

contract ERC20Wallet2out3{

   
   enum State {
       pending,
       complete
   }
   // Declaring a structure
   struct Payout { 
      uint256 qtyAlice;
      uint256 qtyBob;
      uint256 qtyDave;
      address initiatedBy;
      address cosignedBy;
      State state;
   }
   
    event TransferInitiated(address, uint);
    event TransferConfirmed(address, uint);
    
    address alice;
    address bob;
    address dave;
    IERC20 public token;

    uint public nonce = 0; //the index of next payment  
    Payout [] public payouts;  
    
    constructor(address _alice, address _bob, address _dave, address erc20){
        require (_alice != address(0));
        require (_bob   != address(0));
        require (_dave  != address(0));
        require (erc20  != address(0));
        
        alice = _alice;
        bob   = _bob;
        dave  = _dave;
        token = IERC20(erc20);
    }
    

    function initTransfer(uint256 qtyAlice, uint256 qtyBob, uint256 qtyDave) external{
        require(msg.sender == alice || msg.sender == bob || msg.sender == dave, "not an owner");
        payouts.push (Payout(qtyAlice, qtyBob, qtyDave, msg.sender, address(0), State.pending));
        emit TransferInitiated(msg.sender, nonce);
        nonce ++;
    }
    
    function confirmTransfer(uint _nonce) external virtual{
        require(msg.sender == alice || msg.sender == bob || msg.sender == dave, "not an owner");
        require(payouts[_nonce].initiatedBy != msg.sender, "the initiator cannot confirm");
        require(payouts[_nonce].state == State.pending, "incorrect state for payout");
        token.transfer(alice, payouts[_nonce].qtyAlice);
        token.transfer(bob, payouts[_nonce].qtyBob);
        token.transfer(dave, payouts[_nonce].qtyDave);
        payouts[_nonce].state = State.complete;
        payouts[_nonce].cosignedBy = msg.sender;
        emit TransferConfirmed(msg.sender, _nonce);
    }
    
}