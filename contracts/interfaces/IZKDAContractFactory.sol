// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

interface IZKDAContractFactory { 

    function isKnown(address _contract) view external returns (bool _isKnown);

    function getZKAssetContract(address _deedContract, uint256 _deedId) external returns (address _address);

}