pragma solidity >=0.8 <0.9.0;


interface IERC20Approve {
    function approve(address spender, uint256 amount) external returns (bool);
}

interface IERC20Decimals{
    function decimals() external view returns (uint8);
}


//Managed contracts assigns spending power to a 4th party called Agent
//to streamline operations. The parties still keep the power
//to spend with 2-3 logic and in case the Agent will become unavailable
//the parties can always recover funds.

//The Agent has great power and can steal the funds, so it must be choosen
//as a very trustable entity.

contract Managed{
    address public agent;
    constructor( address _agent, address erc20){
        require (_agent != address(0)); //agent must be not null
        agent = _agent;
        uint8 decimals=IERC20Decimals(erc20).decimals();
        IERC20Approve(erc20).approve(agent, 1000000 * 10**decimals); //up to 1 million tokens
    }

}