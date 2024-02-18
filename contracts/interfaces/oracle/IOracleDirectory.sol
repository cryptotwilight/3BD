// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

interface IOracleDirectory { 

    function isSupported(string memory _symbol, string memory _quote) view external returns (bool _isSupported);

    function isSupported(address _nftContract, string memory _quote) view external returns (bool _isSupported);

    function getOracle(string memory _symbol, string memory _quote) view external returns (address _oracle);

    function getOracle(address _nftContract, string memory _quote) view external returns (address _oracle);

}