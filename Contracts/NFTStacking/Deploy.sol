// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./NFTcontract.sol";
import "./RewardToken.sol";
import "./NFTstakingContract.sol";

contract Deployer {

    MyNFT public nft;
    RewardToken public token;
    NFTStaking public staking;

    constructor() {

        nft = new MyNFT();
        token = new RewardToken();

        staking = new NFTStaking(
            address(nft),
            address(token)
        );

        uint256 pool = 500_000 ether;
        token.transfer(address(staking), pool);
    }
}