// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;


interface IZKDeedContract {

    function isKnown(address _zkDeed) view external returns (bool _isKnown);

    function getOwner(address _zkDeed) view external returns (address _owner); 

    function getDeedIds(address _owner) view external returns (uint256 [] memory _deedIds);

    function getZKDeed(uint256 _deedId) view external returns (address _zkDeed);

    function mintZKDeed(address _owner) external returns (uint256 _deedId);

    function burnZkDeed(uint256 _deedId) external returns (address _zkDeed);
}