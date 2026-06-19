// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract Funds{

    address public owner;
    
    mapping (address => uint256) public user;

    address[] public funders;
    // mapping (address[] => uint256) public funders;

    constructor(){
        owner = msg.sender;
    }
    
    modifier OnlyOwner(){
        require(owner == msg.sender,"not allowed");
        _;
    }
    
    function deposite() public payable {
        require(msg.value > 0,"the value mustn't be 0");
        if (user[msg.sender] == 0){
            funders.push(msg.sender);
        }
        user[msg.sender] += msg.value;
    }
//@audit(funder)
    function withdrow() public OnlyOwner {
        uint256 balance = address(this).balance;
        (bool success,) = payable (owner).call{value: balance}("");
        require(success,"procces faild");
    }

    function getfunders() public view OnlyOwner returns(address[] memory){
        return funders;
    }

    function getfunder(uint256 index ) public view OnlyOwner returns(address){
        return funders[index];
    }

    // function sort(uint256  ) public view OnlyOwner returns(address[] memory){

    // }
    function sort_array() public view returns (address[] memory )
    {
        
        address[] memory sorted = funders;
        uint256 l = sorted.length;

        for(uint256 i=0;i<l;i++)
        
        {
            for(uint256 j =i+1;j<l;j++)
            {
                if(sorted[i]<sorted[j])
                {
                    address temp= sorted[j];
                    sorted[j]=sorted[i];
                    sorted[i] = temp;

                }

            }
        }

        return sorted;
    }
    struct Donor{
        address donor;
        uint256 amount;
    }
    //@audit(DOS)
    function GetDonors() public view OnlyOwner returns(Donor[] memory){
        Donor[] memory donors = new Donor[](funders.length);

        for ( uint256 i =0 ; i<funders.length;i++){
            donors[i] = Donor({
                donor : funders[i],
                amount : user[funders[i]]
            });
        }
        return donors;
    }
    // function sortAmount() public view OnlyOwner returns (Donor[] memory )
    // {
        
    //     address[] memory sorted = funders;
    //     uint256 l = sorted.length;
    //     Donor[] memory donors = new Donor[](l);

    //     for(uint256 i=0;i<l;i++)
        
    //     {
    //         for(uint256 j =i+1;j<l;j++)
    //         {
    //             if(sorted[i]<sorted[j])
    //             {
    //                 address temp= sorted[j];
    //                 sorted[j]=sorted[i];
    //                 sorted[i] = temp;
    //                 donors[i] = Donor({
    //                     donor : sorted[i],
    //                     amount : user[sorted[i]]
    //                 });
                
    //             }

    //         }
    //     }

    //     return donors;
    // }
        function sortDonors() public view OnlyOwner returns(Donor[] memory){
        Donor[] memory donors = new Donor[](funders.length);
        

        for ( uint256 i =0 ; i<funders.length;i++){
            donors[i] = Donor({
                donor : funders[i],
                amount : user[funders[i]]
            });
        }
        for(uint256 i=0;i<donors.length;i++)
        
        {
            for(uint256 j =i+1;j<donors.length;j++)
            {
                if(donors[i].amount<donors[j].amount)
                {
                    Donor memory temp= donors[i];
                    donors[i]=donors[j];
                    donors[j] = temp;
                    
                
                }

            }
        }
        return donors;
    }
}