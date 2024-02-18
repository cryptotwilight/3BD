// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import {ZKProof} from "../interfaces/IZKDStructs.sol";

interface IZKProofGenerator {

    function calculateProof(uint256 _convertedValue, address _denomination, uint256 _amount, address _erc20) view external returns (ZKProof memory _proof);
       
}