pragma solidity >=0.8 <0.9.0;


interface IERC20Transfer {
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract EscrowTransaction{
   
    event Released(uint256);
    event Refunded(uint256);
    event Settled(uint256, uint256);
    
    address public buyer;
    address public seller;
    address public arbitrator;


    IERC20Transfer public token;
    
    constructor(
        address _buyer, 
        address _seller, 
        address _arbitrator,
        address erc20){
        //no address can be null
        require (_buyer != address(0));
        require (_seller   != address(0));
        require (_arbitrator != address(0));

        require (erc20  != address(0));
        
        buyer = _buyer;
        seller   = _seller;
        arbitrator = _arbitrator;
        token = IERC20Transfer(erc20);
    }
    

    function release(uint256 amount) external{
        require(msg.sender == buyer, "Only buyer can release funds");
        _transfer(seller, amount);
        emit Released(amount);
    }

    function refund(uint256 amount) external{
        require(msg.sender == seller, "Only seller can refund");
        _transfer(buyer, amount);
        emit Refunded(amount);
    }

    function settle(uint256 refunded, uint256 released) external {
        require(msg.sender == arbitrator, "Only arbitrator can settle" );
        _transfer(buyer, refunded);
        _transfer(seller, released);
        emit Settled(refunded, released);
    }
    
    function _transfer(address to, uint256 amount) internal {
        token.transfer(to, amount);
    }
}
