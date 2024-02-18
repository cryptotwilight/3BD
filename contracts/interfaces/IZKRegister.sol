// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import {Config} from "./IZKDStructs.sol";

interface IZKRegister { 

    function isKnownName(string memory _name)view external returns (bool _isKnownName);

    function isKnownAddress(address _address) view external returns (bool _isKnownAddress);

    function getAddress(string memory _name) view external returns (address _address);

    function getName(address _address) view external returns (string memory _name);

    function getConfig() view external returns (Config [] memory _configuration);

    function getUINTValue(string memory _name) view external returns (uint256 _value);

}