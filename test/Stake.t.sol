// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {StakeContract} from "../src/Stake.sol";

contract StakeTest is Test {
    StakeContract s;

    receive() payable external{}

    function setUp() public {
        s = new StakeContract();
    }

    function testStake() public {
        uint value = 10 ether;
        s.stake{value: value}();
        assertEq(s.totalStaked() , value , "ok");
    }

    function testUnStakeC() public {
        uint value = 20 ether;
        s.stake{value:value}();
        s.unstake(value);

        assert(s.totalStaked() == value/2);
    }

    function testUnStake() public {
        address user = address(0x123);
        uint value = 20 ether;

        // what does deal do
        vm.deal(user, value);

        vm.startPrank(user);
        
        s.stake{value:value}();
        s.unstake(value);

        vm.stopPrank();

        assertEq(s.totalStaked(),value/2);
    }
}
