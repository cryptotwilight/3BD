// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "../../interfaces/IZKVersion.sol";
import "../../interfaces/IZKRegister.sol";
import "../../interfaces/oracle/ICryptoOracle.sol";
import {CryptoOracle, Pair} from "../../interfaces/oracle/IOracleStructs.sol";

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";


contract ChainLinkOracle is ICryptoOracle, IZKVersion {

    string constant name = "RESERVED_CHAIN_LINK_ORACLE";
    uint256 constant version = 1; 

    IZKRegister register; 
    address immutable self; 
    
    mapping(string=>mapping(string=>address)) feedByBaseByQuote; 

    constructor(address _register){
        register = IZKRegister(_register); 
        self = address(this);
        initSupports(); 
    }

    function getName() pure external returns (string memory _name) {
        return name; 
    }

    function getVersion() pure external returns (uint256 _version) {
        return version; 
    }

    function getSupports() view external returns (CryptoOracle memory _oracle) {

        return CryptoOracle({
                                name : name, 
                                oracleAddress : self, 
                                pairs : getPairs() 
                            });
    }

    function getPrice(string memory _base, string memory _quote) view external returns (uint256 _price) {
        (
            /* uint80 roundID */,
            int answer,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        )  = AggregatorV3Interface(feedByBaseByQuote[_quote][_base]).latestRoundData();
        _price = uint256(answer); 
        return _price;
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

   

    function initSupports() internal returns (bool _initialized) {
        feedByBaseByQuote["USD"]["BTC"] = address(0x87dce67002e66C17BC0d723Fe20D736b80CAaFda);
        feedByBaseByQuote["USD"]["DAI"] = address(0x9388954B816B2030B003c81A779316394b3f3f11);
        feedByBaseByQuote["USD"]["ETH"] = address(0x59F1ec1f10bD7eD9B938431086bC1D9e233ECf41);
        feedByBaseByQuote["USD"]["LINK"] = address(0xaC3E04999aEfE44D508cB3f9B972b0Ecd07c1efb);
        feedByBaseByQuote["USD"]["USDC"] = address(0xFadA8b0737D4A3AE7118918B7E69E689034c0127);
        feedByBaseByQuote["USD"]["USDT"] = address(0xb84a700192A78103B2dA2530D99718A2a954cE86);
        return true; 
    }
}  