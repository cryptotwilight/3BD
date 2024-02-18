// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "./IZKDeed.sol";
import {Asset} from "./IZKDStructs.sol" ;

interface IZKDeedAssetContract is IZKDeed { 

    function getValue() view external returns (uint256 _value, address _erc20, uint256 _valuationDate); 

    function getAssets() view external returns (Asset [] memory _assets);    

    function hasAsset(uint256 _assetId) view external returns (bool _hasAsset);

    function addAsset(Asset memory _asset) payable external returns (uint256 _assetId);

    function removeAsset(uint256 _assetId) external returns (Asset memory _asset);

    function updateValue() external returns (uint256 _value, address _erc20, uint256 _valuationDate);
    
    function setDenomination(address _erc20) external returns (bool _demoninationSet);

    function dissolveDeed(address to_) external returns (uint256 _assetCount);

    function updateDescriptor(string memory _descriptor) external returns (bool _updated);
}