// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "../interfaces/IZKVersion.sol";
import "../interfaces/IZKOracle.sol";
import "../interfaces/IZKRegister.sol";

import "../interfaces/oracle/ICryptoOracle.sol";
import "../interfaces/oracle/INFTOracle.sol";
import "../interfaces/oracle/IOracleDirectory.sol";

contract ZKOracle is IZKOracle, IZKVersion {

    string constant name = "RESERVED_ZK_ORACLE"; 
    uint256 constant version = 1; 
    address immutable self; 

    string constant ORACLE_DIRECTORY = "RESERVED_ORACLE_DIRECTORY";


    IZKRegister register; 

    constructor(address _register){
        register = IZKRegister(_register);
        self = address(this);
    }

    function getName() pure external returns (string memory _name){
        return name; 
    }

    function getVersion() pure external returns (uint256 _version) {
        return version; 
    }

    function getPrice(string memory _base, string memory _quote) view external returns (uint256 _price){
        IOracleDirectory directory_ = IOracleDirectory(register.getAddress(ORACLE_DIRECTORY));
        ICryptoOracle oracle_ = ICryptoOracle(directory_.getOracle(_base, _quote));
        return oracle_.getPrice(_base, _quote);
    }

    function getFloorPrice(address _nft, string memory _quote)  view external returns (uint256 _floorPrice){
        IOracleDirectory directory_ = IOracleDirectory(register.getAddress(ORACLE_DIRECTORY));
        INFTOracle oracle_ = INFTOracle(directory_.getOracle(_nft, _quote));
        return oracle_.getFloorPrice(_nft, _quote);
    }


}