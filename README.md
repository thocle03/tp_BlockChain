# Projet : Vérification de l’authenticité de documents PDF sur la Blockchain
## Objectif
Développer un smart contract qui :
Enregistre l’empreinte de documents PDF à partir de 3 métadonnées : titre, taille, date.


Permet de vérifier l’authenticité d’un document via ces métadonnées.


Applique une méthode formelle simple (assertion) pour garantir l’unicité de l’enregistrement.


Fonctionne localement avec Ganache et Hardhat.



## Outils utilisés
Outil
Utilisation
Solidity
Écriture du smart contract
Remix IDE
(optionnel) Écriture rapide et test initial
Hardhat
Compilation, déploiement et test du contrat
Ganache
Réseau local Ethereum simulé
MetaMask
Gestion des comptes et transactions si besoin
Chai + Mocha
Tests unitaires automatisés


Architecture du projet
📁 my-blockchain-project/
├── contracts/
│   └── DocumentVerifier.sol       ← Nouveau contrat
├── scripts/
│   └── deploy.js                  ← Script de déploiement
├── test/
│   └── DocumentVerifier.js        ← Tests unitaires
├── hardhat.config.js
├── package.json


 1. Installation et configuration
npm init -y
npm install --save-dev hardhat
npx hardhat
 Choisir : "Create a JavaScript project"
npm install --save-dev @nomicfoundation/hardhat-toolbox

Configuration Ganache
Dans hardhat.config.js :
module.exports = {
  networks: {
    localhost: {
      url: "http://127.0.0.1:7545" // Port Ganache
    }
  },
  solidity: "0.8.20"
};


### 2. Smart Contract - contracts/DocumentVerifier.sol
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

