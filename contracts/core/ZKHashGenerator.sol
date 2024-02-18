// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;


contract ZKHashGenerator { 


    function sumHashes(int256 a, int256 b) pure external returns (int256 c, bytes32 hashAB, bytes32 hashC){

        c = a + b; 

        hashAB = keccak256(abi.encode(a,b));

        hashC = keccak256(abi.encode(c));

        return (c, hashAB, hashC);
    }


}