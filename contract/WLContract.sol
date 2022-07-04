// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract WlSale is Ownable, Pausable {
    
    using Strings for uint256;

    address public nftAddress;

    uint256 public cost = 0.01 ether;
    uint256 public supply = 0;
    uint256 public maxSupply = 10;
    uint256 public maxMintAmount = 5;

    bytes32 public _merkleRoot = 0x0d47b78b8d3a4e0a5e3405dc35699b14dc1d44e15620ba3fd2cf4855c2081604;
    mapping(address => uint256) public allowList;

    uint64 startTime;
    uint64 endTime;
    uint256 saleCount;

    constructor(address _nftAddress) {
        nftAddress = _nftAddress;
    }

    // public
    function allowMint(
        uint256 _amount,
        uint256 _price,
        bytes32 _salt,
        bytes32[] memory _proof
    ) public payable whenNotPaused {

        require(_amount > 0, "can not call 0");
        require(supply + _amount <= maxSupply, "max minting");
        require(_amount <= maxMintAmount, "The number of minting possible per transaction is 5");
        require(allowList[msg.sender] + _amount <= maxMintAmount, "you can mint 5");
        require(cost * _amount == msg.value, "not eligible for ethers value");
        require(startTime != 0 && getBlockTime() > startTime, "sale has not started yet");
        require(endTime != 0 && getBlockTime() < endTime, "sale finished");

        _checkValidity(maxMintAmount, _price, _salt, _proof);

        allowList[msg.sender] += _amount;
        supply += _amount;

        (bool success, ) = nftAddress.call(abi.encodeWithSignature("saleMint(address,uint256)", msg.sender, _amount));
        require(success, "minting false");
    }

    function getStartTime() public view returns (uint64) {
        return startTime;
    }

    function getEndTime() public view returns (uint64) {
        return endTime;
    }

    //only owner
    function setMerkleRoot(bytes32 _root) public onlyOwner {
        _merkleRoot = _root;
    }

    function setTime(uint64 _start, uint64 _end) public onlyOwner {

        if (_start != startTime) {
            startTime = _start;
        }

        if (_end != endTime) {
            endTime = _end;
        }

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
        _checkValidity(maxMintAmount, _price, _salt, _proof);
        return true;
    }

    // internal
    function _checkValidity(
        uint256 amount,
        uint256 price,
        bytes32 salt,
        bytes32[] memory proof
    ) internal view {
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

}