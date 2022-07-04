// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract PubSale is Ownable, Pausable {
    
    using Strings for uint256;

    address public nftAddress;

    uint256 public cost = 0.03 ether;
    uint256 public supply = 0;
    uint256 public maxSupply = 90;
    uint256 public maxMintAmount = 5;
    uint256 public maxWlMintAmount = 10;

    bytes32 public _merkleRoot = 0x0d47b78b8d3a4e0a5e3405dc35699b14dc1d44e15620ba3fd2cf4855c2081604;
    mapping(address => uint256) public allowList;

    constructor(address _nftAddress) {
        nftAddress = _nftAddress;
    }

    // public
    function pubMint(
        uint256 _amount,
        uint256 _price,
        bytes32 _salt,
        bytes32[] memory _proof
    ) public payable whenNotPaused {

        uint256 mintAmount = 5;

        if (_checkValidity(maxMintAmount, _price, _salt, _proof)) mintAmount = 10;

        require(_amount <= mintAmount, "The number of mintables per transaction has been exceeded.");
        require(_amount > 0, "can not call 0");
        require(supply + _amount <= maxSupply, "max minting");
        require(cost * _amount == msg.value, "not eligible for ethers value");

        
        allowList[msg.sender] += _amount;
        supply += _amount;

        (bool success, ) = nftAddress.call(abi.encodeWithSignature("saleMint(address,uint256)", msg.sender, _amount));
        require(success, "minting false");
    }

    //only owner
    function setMerkleRoot(bytes32 _root) public onlyOwner {
        _merkleRoot = _root;
    }

    function setCost(uint256 _newCost) public onlyOwner {
        cost = _newCost;
    }

    function setMaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
        maxMintAmount = _newmaxMintAmount;
    }

    function setMaxSupply(uint256 _maxSupply) public onlyOwner {
        maxSupply = _maxSupply;
    }

    function withdraw() public payable onlyOwner {
        (bool os, ) = payable(msg.sender).call{value: address(this).balance}("");
        
        require(os);
    }

    function getCeller() public view returns(address) {
        return tx.origin;
    }

    function getBlockTime() public view returns(uint) {
        return block.timestamp;
    }

    function checkWl(
        uint256 _price,
        bytes32 _salt,
        bytes32[] memory _proof
    ) public view returns(bool) {
        return _checkValidity(maxMintAmount, _price, _salt, _proof);
    }

    // internal
    function _checkValidity(
        uint256 amount,
        uint256 price,
        bytes32 salt,
        bytes32[] memory proof
    ) internal view returns(bool) {
        /* solium-disable-next-line security/no-block-members */

        {
            //            bytes32 leaf = _generateLandHash(x, y, size_x, size_y, tier, price, reserved, salt);
            bytes32 leaf = keccak256(
                abi.encodePacked(
                    amount,
                    price,
                    msg.sender,
                    salt
                )
            );

            return _verify(proof, leaf);
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

}