// SPDX-License-Identifier: MIT
pragma solidity =0.6.6;

import "./interfaces/IForbitswapPair.sol";
import "./interfaces/IForbitswapCallee.sol";
import "./interfaces/IForbitswapFactory.sol";

import "./libraries/SafeMath.sol";
import "./libraries/UQ112x112.sol";
import "./libraries/Math.sol";
import "./ForbitswapPair.sol";

contract ForbitswapFactory {
    bytes32 public constant INIT_CODE_PAIR_HASH =
        keccak256(abi.encodePacked(type(ForbitswapPair).creationCode));

    address public feeTo;
    address public feeToSetter;

    mapping(address => mapping(address => address)) public getPair;
    address[] public allPairs;

    event PairCreated(
        address indexed token0,
        address indexed token1,
        address pair,
        uint256
    );

    constructor(address _feeToSetter) public {
        feeToSetter = _feeToSetter;
    }

    function allPairsLength() external view returns (uint256) {
        return allPairs.length;
    }

    function getInitHash(address tokenA, address tokenB)
        public
        pure
        returns (bytes32)
    {
        require(tokenA != tokenB, "ForbitSwap: IDENTICAL_ADDRESSES");
        (address token0, address token1) =
            tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        // bytes memory bytecode = type(ForbitswapPair).creationCode;
        return keccak256(abi.encodePacked(token0, token1));
        // return bytecode;
    }

    function createPair(address tokenA, address tokenB)
        external
        returns (address pair)
    {
        require(tokenA != tokenB, "ForbitSwap: IDENTICAL_ADDRESSES");
        (address token0, address token1) =
            tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(token0 != address(0), "ForbitSwap: ZERO_ADDRESS");
        require(
            getPair[token0][token1] == address(0),
            "ForbitSwap: PAIR_EXISTS"
        ); // single check is sufficient
        bytes memory bytecode = type(ForbitswapPair).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(token0, token1));
        assembly {
            pair := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        IForbitswapPair(pair).initialize(token0, token1);
        getPair[token0][token1] = pair;
        getPair[token1][token0] = pair; // populate mapping in the reverse direction
        allPairs.push(pair);
        emit PairCreated(token0, token1, pair, allPairs.length);
    }

    function setFeeTo(address _feeTo) external {
        require(msg.sender == feeToSetter, "ForbitSwap: FORBIDDEN");
        feeTo = _feeTo;
    }

    function setFeeToSetter(address _feeToSetter) external {
        require(msg.sender == feeToSetter, "ForbitSwap: FORBIDDEN");
        feeToSetter = _feeToSetter;
    }
}
