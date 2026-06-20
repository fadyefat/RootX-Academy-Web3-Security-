// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract NFTStaking is ERC721Holder {

    IERC721 public immutable nft;
    IERC20 public immutable rewardToken;

    uint256 public constant REWARD_PER_DAY = 10 ether;

    struct StakeInfo {
        address owner;
        uint256 stakedAt;
    }

    mapping(uint256 => StakeInfo) public stakes;

    constructor(address _nft, address _rewardToken) {
        nft = IERC721(_nft);
        rewardToken = IERC20(_rewardToken);
    }

    function stake(uint256 tokenId) external {
        nft.safeTransferFrom(msg.sender, address(this), tokenId);

        stakes[tokenId] = StakeInfo({
            owner: msg.sender,
            stakedAt: block.timestamp
        });
    }

    function pendingRewards(uint256 tokenId) public view returns (uint256) {
        StakeInfo memory info = stakes[tokenId];

        if (info.owner == address(0)) return 0;

        uint256 duration = block.timestamp - info.stakedAt;

        return (duration * REWARD_PER_DAY) / 1 days;
    }

    function claim(uint256 tokenId) external {
        StakeInfo storage info = stakes[tokenId];

        require(info.owner == msg.sender, "Not owner");

        uint256 reward = pendingRewards(tokenId);

        require(
            rewardToken.balanceOf(address(this)) >= reward,
            "Insufficient reward pool"
        );

        info.stakedAt = block.timestamp;

        IERC20(rewardToken).transfer(msg.sender, reward);
    }

    function unstake(uint256 tokenId) external {
        StakeInfo storage info = stakes[tokenId];

        require(info.owner == msg.sender, "Not owner");

        uint256 reward = pendingRewards(tokenId);

        delete stakes[tokenId];

        require(
            rewardToken.balanceOf(address(this)) >= reward,
            "Insufficient reward pool"
        );

        IERC20(rewardToken).transfer(msg.sender, reward);

        nft.safeTransferFrom(address(this), msg.sender, tokenId);
    }
}