//SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract FundMe{

    address public owner;

    mapping(address => uint256) public user;

    constructor(){
        owner = msg.sender;
    }

    modifier OnlyOwner()
    {
        require(owner == msg.sender," only owner");
        _;
    } 


    function deposite() public payable {
        require(msg.value > 0,"0 not allowed");
        user[msg.sender] += msg.value;
    }

    function withdraw() public OnlyOwner{
        uint256 balance = address(this).balance;
        (bool success,) = payable (owner).call{value: balance}("");
        require(success,"transfered failed");
    }

}