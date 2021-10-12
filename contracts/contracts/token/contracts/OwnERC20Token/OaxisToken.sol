// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.1;

import '../ERC20/ERC20.sol';

contract OaxisToken is ERC20 {
    constructor(uint256 initialSupply) ERC20("Oaxis", "OXT") {
        _mint(msg.sender, initialSupply * 10**uint256(super.decimals()));
    }
}
