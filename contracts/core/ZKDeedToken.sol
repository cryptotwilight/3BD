// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../interfaces/IZKRegister.sol";
import "../interfaces/IZKDeedToken.sol";
import "../interfaces/IZKVersion.sol";

import {Burn} from "../interfaces/IZKDStructs.sol";

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract ZKDeedToken is ERC20, ERC20Permit, IZKDeedToken, IZKVersion {
    
    modifier poolOnly { 
        require(msg.sender == register.getAddress(ZK_DEED_POOL), "deed pool only");
        _; 
    }
    
    string constant nme = "RESERVED_ZK_DEED_TOKEN";
    uint256 constant version = 1; 

    string constant ZK_DEED_POOL = "RESERVED_ZK_DEED_POOL";
    IZKRegister register; 

    constructor(address _register)
        ERC20("ZKDeedToken", "ZKDT")        
        ERC20Permit("ZKDeedToken"){
        
        register = IZKRegister(_register);
    }

    uint256 [] burnIds; 
    mapping(uint256=>Burn) burnById; 

    function getName() pure external returns (string memory _name) {
        return nme; 
    }


    function getVersion() pure external returns (uint256 _version) {
        return version; 
    }

    function mint(address to, uint256 amount) external poolOnly {
        _mint(to, amount);
    }

    function burn(uint256 _amount) poolOnly external returns (uint256 _burnId) {
        _burn(msg.sender, _amount);
        _burnId = getIndex(); 
        burnIds.push(_burnId);
        burnById[_burnId] = Burn({
                                    id : _burnId,
                                    amount : _amount, 
                                    burnDate : block.timestamp
                                });
        return _burnId;
    }

    //=================================== INTERNAL =======================================
    uint256 index; 

    function getIndex() internal returns (uint256 _index){
        _index  = index++;
        return _index; 
    }
}
