pragma solidity >=0.8 <0.9.0;



import "./ERC20Wallet2out3.sol";

//Managed contracts assigns spending power to a 4th party called Agent
//to streamline operations. The parties still keep the power
//to spend with 2-3 logic and in case the Agent will become unavailable
//the parties can always recover funds.

//The Agent has great power and can steal the funds, so it must be choosen
//as a very trustable entity.

//The Agent can be hired only once at contruction phase but it can be dismissed
//by any of the parties anytime.
contract ERC20Wallet2out3Managed is ERC20Wallet2out3{
    
    //the agent address is a special owner which will receive approve( ) from the 
    //contract and as such able to spend funds on behalf of the contract
    address public agent;
    
    constructor(address _alice, address _bob, address _dave, address _agent, address erc20)
    ERC20Wallet2out3(_alice, _bob, _dave, erc20){
        require (_agent != address(0)); //agent must be not null
        agent = _agent;
        token.approve(agent, 1000000 * 10**18); //up to 1 million tokens
    }

    //this function will dismiss completely the agent and no new agent can be
    //appointed later.
    function dismissAgent() external{
        require (msg.sender == alice || msg.sender == bob); //only the parties can dismiss
        token.approve(agent, 0);
    }


}