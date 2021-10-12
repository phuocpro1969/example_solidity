// SPDX-License-Identifier: MIT
pragma solidity =0.6.6;

interface IForbitswapCallee {
    function ForbitswapCall(
        address sender,
        uint256 amount0,
        uint256 amount1,
        bytes calldata data
    ) external;
}
