// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract ERC20{
    string _name = "Test Token";
    string _symbol = "TT";
    
    mapping (address => uint256) balances;
    
    constructor(){
        balances[msg.sender] = totalSupply();
    }
    
    function name() public view returns  (string memory){
        return _name;
    }

    function symbol() public view returns (string memory){
        return _symbol;
    }

    function decimals() public view returns (uint8){
        return 0;
    }
    
    function totalSupply() public view returns (uint256){
        return 1000;
    }
    
    function balanceOf(address _owner) public view returns (uint256 balance){
        return balances[_owner];
    }
    function transfer(address _to, uint256 _value) public returns (bool success){
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        return true;
    }
}
