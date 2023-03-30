// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract Launchtoken is ERC20 {
    constructor() ERC20("Launch","MG") {
        _mint(msg.sender, 20*10**18);
    }
    
}