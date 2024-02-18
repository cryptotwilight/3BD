// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import {CryptoOracle} from "../../interfaces/oracle/IOracleStructs.sol";

interface ICryptoOracle { 

    function getSupports() view external returns (CryptoOracle memory _oracle);

    function getPrice(string memory _base, string memory _quote) view external returns (uint256 _price);
}