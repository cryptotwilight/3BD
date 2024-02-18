// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "../interfaces/IZKVersion.sol";
import "../interfaces/IZKDAContractFactory.sol";
import "../interfaces/IZKRegister.sol";

import "./ZKDeedAssetContract.sol";

contract ZKDAContractFactory is IZKDAContractFactory, IZKVersion { 

    modifier deedContractOnly {
        require(msg.sender == register.getAddress(ZK_DEED_CONTRACT), "deed contract only");
        _; 
    }

    modifier adminOnly { 
        require(msg.sender == register.getAddress(ZK_ADMIN), " admin only ");
        _; 
    }


    string constant name = "RESERVED_ZKD_ASSET_FACTORY";
    uint256 constant version = 3; 

    string constant ZK_DEED_CONTRACT = "RESERVED_ZK_DEED_CONTRACT";
    string constant ZK_ADMIN = "RESERVED_ZK_ADMIN";
    address immutable self; 

    address [] contracts; 
    mapping(address=>bool) knownContract; 

    IZKRegister register; 

    constructor(address _register) { 
        register = IZKRegister(_register);
    }

    function getName() pure external returns (string memory _name) {
        return name; 
    }

    function getVersion() pure external returns (uint256 _version) {
        return version; 
    }
    
    function getContracts() view external adminOnly returns (address [] memory _contracts) {
        return contracts; 
    }

    function isKnown(address _contract) view external returns (bool _isKnown) {
        return knownContract[_contract];
    }

    function getZKAssetContract(address _deedContract, uint256 _deedId) external deedContractOnly returns (address _address){
        _address = address(new ZKDeedAssetContract(address(register), _deedContract, _deedId));
        contracts.push(_address);
        knownContract[_address] = true; 
        return _address; 
    }

}