// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Challenge {

    address public owner;
    bool public isSolved;

    constructor() {
        owner = msg.sender;
    }

    function becomeOwner() external {
        require(tx.origin == msg.sender, "No contracts");
        owner = msg.sender;
    }

    function solve() external {
        require(msg.sender == owner, "Not owner");
        isSolved = true;
    }
}