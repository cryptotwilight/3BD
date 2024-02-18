// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

interface IZKDeedToken { 

    function mint(address to, uint256 amount) external ;

    function burn(uint256 _amount) external returns (uint256 _burnId); 
}