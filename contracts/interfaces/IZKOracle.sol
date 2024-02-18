// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;


interface IZKOracle { 

    function getPrice(string memory _base, string memory _quote) view external returns (uint256 _price);

    function getFloorPrice(address _nft, string memory _quote)  view external returns (uint256 _floorPrice);

}