// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/token/ERC20/ERC20.sol";

contract StakeContract {
    mapping (address=> uint ) stakedEth;
    uint public totalStaked;

    function stake() payable public{
        uint value = msg.value;
        require(value>0 , "Must deposit some eth to stake");
        address user = msg.sender;
        stakedEth[user] += value;
        totalStaked += value;
    }

    function unstake(uint _value) public{
        require(_value>0 , "Withdrawal amount must be greater than 0");
        require(_value<=stakedEth[msg.sender], "Withdrawal amount must be within limits of your balance");

        // buggy line , withdrawing _value but sending only half - setup for upgradablility
        payable(msg.sender).transfer(_value/2);
        totalStaked -= _value/2;
        stakedEth[msg.sender] -= _value; 
    }
}
