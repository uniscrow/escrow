pragma solidity >=0.8 <0.9.0;


interface IERC20Approve {
    function approve(address spender, uint256 amount) external returns (bool);
}



//Managed contracts assigns spending power to a 4th party called Agent
//to streamline operations. The parties still keep the power
//to spend with 2-3 logic and in case the Agent will become unavailable
//the parties can always recover funds.

//The Agent has great power and can steal the funds, so it must be choosen
//as a very trustable entity.

contract Managed{
    address public agent;
    constructor( address _agent, address erc20, uint256 allowance){
        require (_agent != address(0)); //agent must be not null
        agent = _agent;
        IERC20Approve(erc20).approve(agent, allowance); //up to 1 million tokens
    }

}