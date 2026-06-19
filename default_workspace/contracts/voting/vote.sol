// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract vote {
    address public Owner;
    uint256 public Iphone_17ProMax ;
    uint256 public Samsung_s26 ;
    mapping (address => bool) hasVoted;
    address[ ] public IphoneFans;
    address[ ] public SamsungFans;
    // struct product{
        

    // }
    constructor(){

        Owner = msg.sender;

    }
    modifier OnlyOwner{
        require(Owner == msg.sender,"not allowed");
        _;
    } 

    function voteing(uint256 VoteNum ) public {
        require(!hasVoted[msg.sender],"already voted");
        require(VoteNum == 1 || VoteNum == 2,"not valid");
        if (VoteNum == 1){
            IphoneFans.push(msg.sender);
            Iphone_17ProMax++;
        }
        else {
            SamsungFans.push(msg.sender);
            Samsung_s26++;    
        }
        hasVoted[msg.sender]=true;
    }
    function retrive( ) public view OnlyOwner returns(uint256,uint256){
        uint256 iphonevoters = IphoneFans.length;
        uint256 samsungvoters = SamsungFans.length;
        return (iphonevoters,samsungvoters);
    }
}