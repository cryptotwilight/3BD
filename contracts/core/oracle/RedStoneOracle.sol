// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "../../interfaces/IZKVersion.sol";
import "../../interfaces/IZKRegister.sol";
import "../../interfaces/oracle/ICryptoOracle.sol";

import {Pair} from "../../interfaces/oracle/IOracleStructs.sol";

import "@redstone-finance/evm-connector/contracts/data-services/MainDemoConsumerBase.sol";


contract RedStoneOracle is MainDemoConsumerBase, ICryptoOracle, IZKVersion {

    string constant name = "RESERVED_RED_STONE_ORACLE";
    uint256 constant version = 2; 

    IZKRegister register; 
    address immutable self; 

    constructor(address _register){
        register = IZKRegister(_register); 
        self = address(this);
    }

    function getName() pure external returns (string memory _name) {
        return name; 
    }

    function getVersion() pure external returns (uint256 _version) {
        return version; 
    }

    function getSupports() view external returns (CryptoOracle memory _oracle){

    }

    

    function getPrice(string memory _base, string memory _quote) view external returns (uint256 _price) {
        return getOracleNumericValueFromTxMsg(bytes32(abi.encode(_base)));
    }

// ================================= INTERNAL ======================================
    
    function getPairs() pure internal returns (Pair [] memory _pairs) {
        _pairs = new Pair[](6);
        _pairs[0] = getPair("BTC", "USD");
        _pairs[1] = getPair("DAI", "USD");
        _pairs[2] = getPair("ETH", "USD");
        _pairs[3] = getPair("LINK", "USD");
        _pairs[4] = getPair("USDC", "USD");
        _pairs[5] = getPair("USDT", "USD");
        return _pairs; 
    }

    function getPair(string memory _base, string memory _quote) pure internal returns (Pair memory _pair) {
        return Pair({
                    base : _base, 
                    quote : _quote
                    });
    }
}