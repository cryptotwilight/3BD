// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;


struct Pair {
    string base; 
    string quote; 
}

struct NFT { 
    address nftContract; 
    string quote; 
}

struct CryptoOracle { 
    string name; 
    address oracleAddress; 
    Pair [] pairs; 
}

struct NFTOracle {
    string name; 
    address oracleAddress; 
    NFT [] nfts; 
}