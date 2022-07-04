// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract Material is ERC1155, Ownable {
    
    uint256 public constant GOLD = 0;
    uint256 public constant SILVER = 1;
    uint256 public constant THORS_HAMMER = 2;
    uint256 public constant SWORD = 3;
    uint256 public constant SHIELD = 4;
    uint256 public constant cost = 1 ether;
    mapping(address => uint256) public point;

    constructor() public ERC1155("https://game.example/api/item/{id}.json") {
    }

    function _beforeTokenTransfer(
        address operator, 
        address from, 
        address to, 
        uint256[] memory ids, 
        uint256[] memory amounts, 
        bytes memory data
    ) internal override {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
        if (msg.value >= 0) {
            payable(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4).call{value: (msg.value / 100) * 5}("");
        }

        point[0x5B38Da6a701c568545dCfcB03FcB875f56beddC4]++;
    }

    function mint(uint256 _id, uint256 _amount) public payable {
        require(msg.value == _amount * cost);

        point[msg.sender] = _amount;
        _mint(msg.sender, _id, _amount, "");
    }

    function mix(address _ntz, uint256 _id, uint256 _amount) public payable {

        require(_amount >= 3, "less amount");
        require(_amount%3 == 0, "3 amount");

        _burn(msg.sender, _id, _amount);

        (bool success, ) = _ntz.call(abi.encodeWithSignature("mint(address,uint256)", msg.sender, _amount));
        require(success, "working failed");
    }

    function getPoint(address _addr) public view returns (uint256) {
        return point[_addr];
    }

}