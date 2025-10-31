// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {Ark} from "../src/Ark.sol";

contract StakeTest is Test {
    Ark coin;

    receive() payable external{}

    function setUp() public {
        coin = new Ark(address(this));
    }

    function testRevertMintingForNonOwner() public {
        vm.prank(address(0x123));
        vm.expectRevert();
        coin.mint(address(0x123), 20);
    }

    function testMinting() public {
        address user = address(0x123);
        coin.mint(user, 10);
        assert(coin.balanceOf(user) == 10);
    }

    function testChangingContract() public {
        coin.updateContract(address(0x123));
        assert(coin.stakingContract() == address(0x123));
    }

    function testRevertChangingContractForNonOwner() public {
        vm.prank(address(0x123));
        vm.expectRevert();
        coin.updateContract(address(0x234));
    }
}
