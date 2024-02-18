// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import {ZKProof, AssetType, ZKComposition} from "./IZKDStructs.sol";

interface IZKDeed { 
    
    function getDenomination() view external returns (address _erc20);

    function getDescriptor() view external returns (string memory _descriptor);

    function getComposition() view external returns (ZKComposition memory _composition);

    function hasType(AssetType _type) view external returns (bool _hasType);

    function isLocked() view external returns (bool _isLocked);

    function isAboveValue(uint256 _amount, address _erc20) view external returns (bool _isAboveValue, ZKProof memory _proof);

    function getDeedContract() view external returns (address _deedContract);

    function getDeedContractId() view external returns (uint256 _deedContractId);

    function lockDeed() external returns (bool _isLocked);

    function unlockDeed() external returns (bool _isLocked);

}