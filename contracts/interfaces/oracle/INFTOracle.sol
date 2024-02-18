// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import {NFTOracle} from "../../interfaces/oracle/IOracleStructs.sol";

interface INFTOracle { 

    function getSupports() view external returns (NFTOracle memory _oracle);

    function getFloorPrice(address _nftContact, string memory _quoteSymbol) view external returns (uint256 _price); 

}