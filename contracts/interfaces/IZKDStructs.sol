// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

enum TxType {DEED_DEPOSIT, DEED_WITHDRAW, BORROW, REPAY}

struct TX { 
    uint256 id; 
    address deedContract;
    uint256 deedId; 
    uint256 amount; 
    address currency; 
    TxType txType; 
}

struct Burn {
    uint256 id; 
    uint256 amount; 
    uint256 burnDate; 
}

struct ZKProof { 
    address prover; 
    address denomination; 
    string proof; 
    uint256 amount; 
    address erc20; 
    uint256 createDate; 
}

struct ZKComposition { 

    uint256 erc20; 
    uint256 erc721; 
    uint256 erc1155; 
}

struct Asset {
    uint256 id;  
    AssetType aType; 
    address assetContract; 
    uint256 amount; 
    uint256 assetContractId; 
}

enum AssetType {ERC20, ERC721, ERC1155}

struct Config { 
    string name; 
    address addr; 
    uint256 version; 
}