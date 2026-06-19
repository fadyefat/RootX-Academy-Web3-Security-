// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;

contract voteing {
   struct voter{
       uint8 id;
       uint8 CandidateNumber;
       string RealAddress;
   }
   voter[] public voters;
   mapping(address => bool) public hasVoted;
   address public owner;

   constructor() {
        owner = msg.sender;
    }

   modifier OnlyOwner() {
        require(owner == msg.sender, " only owner");
        _;
    }

   function number_of_voter() public view OnlyOwner returns (uint256) {
       return voters.length;
   }

   function store(uint8 _id, uint8 _candidateNumber, string memory _realAddress) public OnlyOwner {
       voters.push(voter(_id, _candidateNumber, _realAddress));
   }

   function vote(uint8 _id, uint8 _candidateNumber, string memory _realAddress) public {
       require(!hasVoted[msg.sender], "You have already voted!");
       hasVoted[msg.sender] = true;
       store(_id, _candidateNumber, _realAddress);
   }
}