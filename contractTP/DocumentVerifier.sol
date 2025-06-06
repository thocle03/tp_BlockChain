// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DocumentVerifier {
    struct Document {
        bytes32 hash;        
        address owner;       
    }

    mapping(bytes32 => Document) public documents;

    event DocumentRegistered(bytes32 indexed docHash, address indexed owner);

    function registerDocument(string memory title, uint size, string memory pubDate) public {
        bytes32 hash = keccak256(abi.encodePacked(title, size, pubDate));

        assert(documents[hash].owner == address(0)); 

        documents[hash] = Document({
            hash: hash,
            owner: msg.sender
        });

        emit DocumentRegistered(hash, msg.sender);
    }

    function verifyDocument(string memory title, uint size, string memory pubDate) public view returns (bool) {
        bytes32 hash = keccak256(abi.encodePacked(title, size, pubDate));
        return documents[hash].owner != address(0);
    }
}
