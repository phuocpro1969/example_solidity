pragma solidity =0.6.6;
import "../../libraries/SafeMath.sol";

contract ForbitswapERC20 {
    using SafeMath for uint256;
    string public constant nameOfToken = "ForbitSwap LP Token";
    string public constant symbolOfToken = "JLP";
    uint8 public constant decimalsOfToken = 18;
    uint256 public totalSupplyOfToken;
    mapping(address => uint256) public balanceOfAddress;
    mapping(address => mapping(address => uint256)) public allowanceOfAdress;

    bytes32 public DOMAIN_SEPARATOR_TOKEN;
    // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
    bytes32 public constant PERMIT_TYPEHASH_TOKEN =
        0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
    mapping(address => uint256) public noncesFobitswapToken;

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event Transfer(address indexed from, address indexed to, uint256 value);

    constructor() public {
        uint256 chainId;
        assembly {
            chainId := chainid()
        }
        DOMAIN_SEPARATOR_TOKEN = keccak256(
            abi.encode(
                keccak256(
                    "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
                ),
                keccak256(bytes(nameOfToken)),
                keccak256(bytes("1")),
                chainId,
                address(this)
            )
        );
    }

    function _mint(address to, uint256 value) internal {
        totalSupplyOfToken = totalSupplyOfToken.add(value);
        balanceOfAddress[to] = balanceOfAddress[to].add(value);
        emit Transfer(address(0), to, value);
    }

    function _burn(address from, uint256 value) internal {
        balanceOfAddress[from] = balanceOfAddress[from].sub(value);
        totalSupplyOfToken = totalSupplyOfToken.sub(value);
        emit Transfer(from, address(0), value);
    }

    function _approve(
        address owner,
        address spender,
        uint256 value
    ) private {
        allowanceOfAdress[owner][spender] = value;
        emit Approval(owner, spender, value);
    }

    function _transfer(
        address from,
        address to,
        uint256 value
    ) private {
        balanceOfAddress[from] = balanceOfAddress[from].sub(value);
        balanceOfAddress[to] = balanceOfAddress[to].add(value);
        emit Transfer(from, to, value);
    }

    function approveToSpender(address spender, uint256 value)
        external
        returns (bool)
    {
        _approve(msg.sender, spender, value);
        return true;
    }

    function transferValueTo(address to, uint256 value)
        external
        returns (bool)
    {
        _transfer(msg.sender, to, value);
        return true;
    }

    function transferValueFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool) {
        if (allowanceOfAdress[from][msg.sender] != uint256(-1)) {
            allowanceOfAdress[from][msg.sender] = allowanceOfAdress[from][
                msg.sender
            ]
                .sub(value);
        }
        _transfer(from, to, value);
        return true;
    }

    function permitSignals(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external {
        require(deadline >= block.timestamp, "ForbitSwap: EXPIRED");
        bytes32 digest =
            keccak256(
                abi.encodePacked(
                    "\x19\x01",
                    DOMAIN_SEPARATOR_TOKEN,
                    keccak256(
                        abi.encode(
                            PERMIT_TYPEHASH_TOKEN,
                            owner,
                            spender,
                            value,
                            noncesFobitswapToken[owner]++,
                            deadline
                        )
                    )
                )
            );
        address recoveredAddress = ecrecover(digest, v, r, s);
        require(
            recoveredAddress != address(0) && recoveredAddress == owner,
            "ForbitSwap: INVALID_SIGNATURE"
        );
        _approve(owner, spender, value);
    }
}
