// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../lib/forge-std/src/console.sol";
import {Test} from "forge-std/Test.sol";
import "../src/StakingCOntract.sol";
import "../src/Ark.sol";

// contract StakeTest is Test {
//     StakingContract s;

//     receive() payable external{}

//     function setUp() public {
//         s = new StakingContract();
//     }
    
//     function testStake() public {
//         uint val = 10 ether;
//         address user = address(0x123);
//         vm.deal(user,val);
//         vm.prank(user);
//         s.stake{value:val}();

//         assert(s.totalStaked() == val);
//         assert(s.staked(user) == val);
//     }

//     function testUnstake() public {
//         uint val = 10 ether;
//         address user = address(0x123);

//         vm.deal(user,val);
//         vm.startPrank(user);
//         s.stake{value:val}();
//         s.unStake(val);
//         vm.stopPrank();

//         // assert(s.staked(user)==0);
//         // mapping(address => uint) public staked;
//         // and it’s marked public, Solidity automatically generates a getter function for it.
//         // Solidity creates a function for you, equivalent to:
//         // function staked(address _user) external view returns (uint) {
//         //     return staked[_user];
//         // }

         
//         assert(s.balance(user)==0);
//         assert(s.totalStaked()==0);
//     }
// }

contract StakeTest is Test {
    StakingContract stakingcontract;
    Ark ArkaCoin;

    function setUp() public {
        ArkaCoin = new Ark(address(this));
        stakingcontract = new StakingContract(IArkaToken(address(ArkaCoin)));
        ArkaCoin.updateContract(address(stakingcontract));
    }

    function testStake() public {
        uint val = 10 ether;
        address user = address(0x123);
        vm.deal(user, val);

        vm.prank(user);
        stakingcontract.stake{value:val}(val);

        assert(stakingcontract.totalStaked() == val);
    }

    function testRevertForStake() public {
        uint val = 10 ether;
        address user = address(0x123);
        vm.deal(user, val);

        vm.startPrank(user);
        stakingcontract.stake{value:val}(val);

        vm.expectRevert();
        stakingcontract.unStake(20 ether);
    }

    function testGetRewards() public {
        uint val = 10 ether;
        address user = address(0x123);
        vm.deal(user, val);

        vm.startPrank(user);
        stakingcontract.stake{value:val}(val);

        vm.warp(block.timestamp + 1);

        uint rewards = stakingcontract.getRewards();
        vm.stopPrank();

        assert(rewards == 10 ether);
    }

    function testMoreGetRewards() public {
        uint val = 10 ether;
        address user = address(0x123);
        vm.deal(user, 50 ether);

        vm.startPrank(user);
        stakingcontract.stake{value:val}(val);

        vm.warp(block.timestamp + 1);
        console.log(block.timestamp);

        stakingcontract.stake{value:val}(val);
        vm.warp(block.timestamp + 1);

        uint rewards = stakingcontract.getRewards();
        vm.stopPrank();

        assert(rewards == 30 ether);
    }

    function testRedeemRewards() public {
        uint val = 10 ether;
        address user = address(0x123);
        vm.deal(user, val);

        vm.startPrank(user);
        stakingcontract.stake{value:val}(val);

        vm.warp(block.timestamp + 1);

        stakingcontract.claimRewards();

        vm.stopPrank();

        console.log("Balance: ");

        // vm.startPrank(user) changes who the test calls as — not who the test is.
        // console.log(ArkaCoin.balanceOf(address(this)));
        // so this will show the balance of the test contract

        
        console.log(ArkaCoin.balanceOf(user));

        // same error as above
        // assert(ArkaCoin.balanceOf(address(this)) == 10 ether);

        
        assert(ArkaCoin.balanceOf(user) == 10 ether);
    }
}