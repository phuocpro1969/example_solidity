// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.1;

import "./ERC20/ERC20.sol";

contract p1Token is ERC20 {
    constructor(uint256 initialSupply) ERC20("p1", "p1") {
        _mint(msg.sender, initialSupply * 10**uint256(super.decimals()));
    }
}
