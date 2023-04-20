// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

/**
 * @title IERC20Approve interface for the approve function of ERC20 tokens.
 */
interface IERC20Approve {
    function approve(address spender, uint256 amount) external returns (bool);
}

/**
 * @title Managed contract that assigns spending power to a 4th party called Agent.
 * @author Davide Carboni

 * @dev Managed contracts assign spending power to an Agent to streamline operations.
 * The parties still keep the power to spend with 2-3 logic, and in case the Agent
 * becomes unavailable, the parties can always recover funds. The Agent has great
 * power and can steal the funds, so it must be chosen as a very trustable entity.
 */
contract Managed {
    address public immutable agent;

    /**
     * @notice Creates a new Managed contract.
     * @param _agent The address of the agent.
     * @param erc20 The address of the ERC20 token used for payments.
     * @param allowance The maximum amount of tokens that the agent is allowed to spend.
     */
    constructor(address _agent, address erc20, uint256 allowance) {
        require(_agent != address(0), "Agent must be not null");
        agent = _agent;
        IERC20Approve(erc20).approve(agent, allowance); // Up to 1 million tokens
    }
}
