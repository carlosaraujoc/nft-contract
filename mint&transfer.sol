//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract cryptoken{
    address public minter;
    mapping(uint256 => address) public tokenOwner;
    mapping(address => uint256) public ownedTokens;

    event Sent(address from, address to, uint256 tokenID);


    constructor(){
        minter = msg.sender;
    }

    function _exists(uint256 tokenID) public view returns (bool){
        address owner = tokenOwner[tokenID];
        return owner != address(0);
    }

    function mint(uint256 tokenID) public{
        require(!_exists(tokenID), "Token ja existe");
        require(msg.sender == minter);
        tokenOwner[tokenID] = msg.sender;
        ownedTokens[msg.sender] += 1;
    }
    
    function _ownerOf(uint256 tokenID) internal view  returns(address){
        address owner = tokenOwner[tokenID];
        require(owner != address(0), "Esse token nao existe");
        return owner;
    }

    function send(address receiver, uint256 tokenID) public{
        require(_ownerOf(tokenID) == msg.sender);
        require(receiver != address(0), "Esse endereco nao existe");
        tokenOwner[tokenID] = receiver;
        ownedTokens[receiver] += 1;
        ownedTokens[msg.sender] -= 1;

        emit Sent(msg.sender, receiver, tokenID);
    }
}