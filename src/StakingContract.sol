// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/token/ERC20/ERC20.sol";

interface IARKATOKEN {
    function mint(address to , uint _val) external;
}

contract StakingContract{
    mapping(address => uint) public staked;
    uint public totalStaked;
    uint public constant REWARD_PER_SEC_PER_ETH = 1; 

    IARKATOKEN public arkaToken;

    struct UserInfo{
        uint stakedAmount;
        uint rewardDept;
        uint lastUpdate;
    }

    mapping(address => UserInfo) public userInfo;

    constructor(IARKATOKEN _token){
        arkaToken = _token;
    }

    function _updateRewards(address _user) internal {
        UserInfo storage user = userInfo[_user];

        if(user.lastUpdate == 0){
            user.lastUpdate = block.timestamp;
            return;
        }

        uint timeDiff = block.timestamp - user.lastUpdate;
        if(timeDiff == 0){
            return;
        }

        uint additionalReward = (user.stakedAmount * timeDiff * REWARD_PER_SEC_PER_ETH);

        user.rewardDept += additionalReward;
        user.lastUpdate = block.timestamp;
    }

    function stake(uint _val) public payable {
        uint value = msg.value;
        require(value > 0 , "Staking amount must be >0");
        require(value == _val , "ETH amount mismatched");

        _updateRewards(msg.sender);

        userInfo[msg.sender].stakedAmount += value;
        totalStaked += value;
    }

    function unStake(uint _value) public {
        require(_value>0 , "Amount must be >0");
        UserInfo storage user = userInfo[msg.sender];
        require(user.stakedAmount >= _value,"Cannot unstake more than staked amount");

        _updateRewards(msg.sender);
        user.stakedAmount -= _value;
        totalStaked -= _value;

        payable(msg.sender).transfer(_value);
    }

    function getRewards() public view returns (uint) {
        UserInfo storage user = userInfo[msg.sender];
        uint timeDiff = block.timestamp - user.lastUpdate;
        if(timeDiff == 0){
            return user.rewardDept;
        }

        return (timeDiff * user.stakedAmount * REWARD_PER_SEC_PER_ETH) + user.rewardDept;
    }

    function claimRewards() public {
        _updateRewards(msg.sender);
        UserInfo storage user = userInfo[msg.sender];
        arkaToken.mint(msg.sender, user.rewardDept);
        user.rewardDept = 0;
    }

    function balance(address user) public view returns (uint) {
        return staked[user];
    }
    
}