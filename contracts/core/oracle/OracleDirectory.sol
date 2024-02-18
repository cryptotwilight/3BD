// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "../../interfaces/IZKVersion.sol";
import "../../interfaces/IZKRegister.sol";
import "../../interfaces/oracle/IOracleDirectory.sol";
import "../../interfaces/oracle/ICryptoOracle.sol";
import "../../interfaces/oracle/INFTOracle.sol";

import {CryptoOracle, NFTOracle, Pair, NFT}  from "../../interfaces/oracle/IOracleStructs.sol";


contract OracleDirectory is IOracleDirectory, IZKVersion { 

    modifier adminOnly { 
        require(msg.sender == register.getAddress(ZK_ADMIN), "admin only");
        _; 
    }

    string constant name = "RESERVED_ORACLE_DIRECTORY";
    uint256 constant version = 3; 

    string constant ZK_ADMIN = "RESERVED_ZK_ADMIN";

    mapping(string=>mapping(string=>bool)) isSupportedByBaseByQuote; 
    mapping(string=>mapping(address=>bool)) isSupportedByNFTContractByQuote; 
    mapping(string=>mapping(string=>address[])) oracleByBaseByQuote; 
    mapping(string=>mapping(address=>address[])) oracleByNFTContractByQuote; 

    string [] oracleNames; 

    IZKRegister register; 

    constructor(address _register) {
        register = IZKRegister(_register);
    }

    function getName() pure external returns (string memory _name) {
        return name; 
    }

    function getVersion() pure external returns (uint256 _version) {
        return version; 
    }

    function getOracleNames() view external returns (string [] memory _names) {
        return oracleNames; 
    }

    function isSupported(string memory _base, string memory _quote) view external returns (bool _isSupported) {
        return isSupportedByBaseByQuote[_quote][_base];
    }

    function isSupported(address _nftContract, string memory _quote) view external returns (bool _isSupported) {
        return isSupportedByNFTContractByQuote[_quote][_nftContract];
    }

    function getOracle(string memory _base, string memory _quote) view external returns (address _oracle) {
        require(isSupportedByBaseByQuote[_quote][_base], "symbol not supported");
        return oracleByBaseByQuote[_quote][_base][0];
    }

    function getOracle(address _nftContract, string memory _quote) view external returns (address _oracle) {
        require(isSupportedByNFTContractByQuote[_quote][_nftContract], "contract & quote not supported" );
        return oracleByNFTContractByQuote[_quote][_nftContract][0];
    }

    function registerCryptoOracle(address _oracle) external adminOnly returns (bool _added) { 
        return addCyptoOracleInternal(ICryptoOracle(_oracle).getSupports());
        
    }

    function registerNFTOracle(address _oracle) external adminOnly returns (bool added) {
        return addNFTOracleInternal(INFTOracle(_oracle).getSupports()); 
    }


    //==================================== INTERNAL =============================================

    function addCyptoOracleInternal(CryptoOracle memory _oracle) internal returns (bool _added){
        for(uint256 x = 0; x < _oracle.pairs.length; x++) {
            Pair memory pair_ = _oracle.pairs[x];
            oracleByBaseByQuote[pair_.quote][pair_.base].push(_oracle.oracleAddress); 
            isSupportedByBaseByQuote[pair_.quote][pair_.base] = true; 
        }
        oracleNames.push(_oracle.name);
        return true; 
    }

    function addNFTOracleInternal(NFTOracle memory _oracle) internal returns (bool _added) {
        for(uint256 x = 0; x < _oracle.nfts.length; x++) {
            NFT memory nft_ = _oracle.nfts[x];
            isSupportedByNFTContractByQuote[nft_.quote][nft_.nftContract] = true; 
            oracleByNFTContractByQuote[nft_.quote][nft_.nftContract].push(_oracle.oracleAddress);
        }
        return true; 
    }

}