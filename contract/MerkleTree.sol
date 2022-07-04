// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MerkleTree is Ownable{

    bytes32 public _merkleRoot = 0xc84063c95aa7d80decd37b649a63c3239b01136922f9009a7e5fedaff8d34d84;

    mapping(address => bool) wl;

    function buyItemWithETH(
        address buyer,
        address reserved,
        address to,
        uint256 amount,
        uint256 price,
        bytes32 salt,
        bytes32[] calldata proof
    ) external payable {
        //        require(_etherEnabled, "ether payments not enabled");
        _checkValidity(buyer, reserved, amount, price, salt, proof);
   
        wl[to] = true;
    }

    function _checkValidity(
        address buyer,
        address reserved,
        uint256 amount,
        uint256 price,
        bytes32 salt,
        bytes32[] memory proof
    ) internal view {
        /* solium-disable-next-line security/no-block-members */
        require(buyer == msg.sender, "not authorized");
        require(reserved == address(0) || reserved == buyer, "cannot buy reserved item");
        {
            //            bytes32 leaf = _generateLandHash(x, y, size_x, size_y, tier, price, reserved, salt);
            bytes32 leaf = keccak256(
                abi.encodePacked(
                    amount,
                    price,
                    reserved,
                    salt
                )
            );
            require(_verify(proof, leaf), "invalid land brick provided");
        }
    }

    function _verify(bytes32[] memory proof, bytes32 leaf) internal view returns (bool) {
        bytes32 computedHash = leaf;

        for (uint256 i = 0; i < proof.length; i++) {
            bytes32 proofElement = proof[i];

            if (computedHash < proofElement) {
                computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
            } else {
                computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
            }
        }

        return computedHash == _merkleRoot;
    }

    //owner

    function setMerkleRoot(bytes32 _root) public onlyOwner {
        _merkleRoot = _root;
    }

}