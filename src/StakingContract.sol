// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/token/ERC20/ERC20.sol";

contract StakingContract{
    mapping(address => uint) public staked;
    uint public totalStaked;

    constructor(){}

    function stake() public payable {
        uint value = msg.value;
        require(value > 0);
        staked[msg.sender] += value;
        totalStaked += value;
    }

    function unStake(uint _value) public {
        require(staked[msg.sender] >= _value);
        payable(msg.sender).transfer(_value);
        staked[msg.sender] -= _value;
        totalStaked -= _value;
    }

    function getRewards() public {

    }

    function claimRewards() public {

    }
    
}