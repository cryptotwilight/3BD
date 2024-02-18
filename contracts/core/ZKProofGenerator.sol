// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "../interfaces/IZKVersion.sol";
import "../interfaces/IZKProofGenerator.sol";
import "../interfaces/IZKRegister.sol";

contract ZKProofGenerator is IZKProofGenerator, IZKVersion {

    string constant name = "RESERVED_ZK_PROOF_GENERATOR"; 
    uint256 constant version = 1; 
    address immutable self; 

    IZKRegister register; 

    constructor(address _register) {
        register = IZKRegister(_register);
        self = address(this);
    }

    function getName() pure external returns (string memory _name) {
        return name; 
    }

    function getVersion() pure external returns (uint256 _version) {
        return version; 
    }


   function calculateProof(uint256 _convertedValue, address _denomination, uint256 _amount, address _erc20) view external returns (ZKProof memory _proof) {
        string memory proof_ = ""; 
        // generate proof on chain  
        return ZKProof({
                            prover : self, 
                            denomination : _denomination,
                            proof : proof_,
                            amount : _amount, 
                            erc20 : _erc20,
                            createDate : block.timestamp
                        }); 
    }

}