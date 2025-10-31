// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/token/ERC20/ERC20.sol";
// import "@openzeppelin/


contract Ark is ERC20{
    address public stakingContract;

    constructor(address _stakingContract) ERC20("ArkCoin","ARK"){
        stakingContract = _stakingContract;
    }

    modifier onlyContract(){
        require(stakingContract == msg.sender);
        _;
    }

    function mint(address to , uint _val) public onlyContract{
        _mint(to, _val);
    }

    function updateContract(address newContract) public onlyContract{
        stakingContract = newContract;
    }
}