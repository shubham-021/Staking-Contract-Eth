// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {StakingContract} from "../src/StakingCOntract.sol";

contract StakeTest is Test {
    StakingContract s;

    receive() payable external{}

    function setUp() public {
        s = new StakingContract();
    }
    
    function testStake() public {
        uint val = 10 ether;
        address user = address(0x123);
        vm.deal(user,val);
        vm.prank(user);
        s.stake{value:val}();

        assert(s.totalStaked() == val);
        assert(s.staked(user) == val);
    }

    function testUnstake() public {
        uint val = 10 ether;
        address user = address(0x123);

        vm.deal(user,val);
        vm.startPrank(user);
        s.stake{value:val}();
        s.unStake(val);
        vm.stopPrank();

        assert(s.staked(user)==0);
        assert(s.totalStaked()==0);
    }
}