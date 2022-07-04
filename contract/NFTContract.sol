// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

contract NTtttest is ERC721A, Ownable, VRFConsumerBaseV2  {
    VRFCoordinatorV2Interface COORDINATOR;

    using Strings for uint256;

    string private baseURI;
    string public baseExtension = ".json";
    uint256 public _cap = 100;
    uint256 public devCap;
    address saleContract;
    bool public paused = false;
    bool public revealed = false;
    string public notRevealedUri;

    // vrf2 
    uint64 s_subscriptionId;
    address vrfCoordinator = 0x6168499c0cFfCaCD319c818142124B7A15E857ab;
    bytes32 keyHash = 0xd89b2bf150e3b9e13446986e571fb9cab24b13cea0a43ea20a6049a85cc807cc;
    uint256 public s_requestId;
    uint32 callbackGasLimit = 300000;
    uint16 requestConfirmations = 3;
    uint32 numWords =  1;
    uint256 tokenOffset;

    constructor(
        string memory _initNotRevealeUri,
        uint64 subscriptionId
    ) ERC721A("NTCoreTest", "NTC") VRFConsumerBaseV2(vrfCoordinator) {
        setNotRevealUri(_initNotRevealeUri);
        s_subscriptionId = subscriptionId;
        COORDINATOR = VRFCoordinatorV2Interface(vrfCoordinator);
    }

    modifier isPause() {
        require(!paused, "this smart contract paused");
        _;
    }

    modifier onlySaleContract() {
        require(_saleContract() == _msgSender(), "SaleContract: caller is not the SaleContract");
        _;
    }

    //hook
    function _beforeTokenTransfers(
        address from,
        address to,
        uint256 startTokenId,
        uint256 quantity
    ) internal override isPause{
        super._beforeTokenTransfers(from, to, startTokenId, quantity);
    }

    function _afterTokenTransfers(
        address from,
        address to,
        uint256 startTokenId,
        uint256 quantity
    ) internal override {
        super._afterTokenTransfers(from, to, startTokenId, quantity);
    }

    // internal
    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }


    // public
    function saleMint(address to, uint256 amount) public onlySaleContract isPause {
        require(totalSupply() + amount < _cap, "total supply has reached to cap");
        require(amount > 0, "amoutn should be greater than 0");

        _safeMint(to, amount);
    }

    function devMint(address to, uint256 amount) public onlyOwner isPause {
        require(totalSupply() + amount < _cap, "total supply has reached to cap");

        _safeMint(to, amount);
    }

    function _saleContract() public view returns (address) {
        return saleContract;
    }


    function numberMinted(address owner) public view returns (uint256) {
        return _numberMinted(owner);
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        if (revealed == false) {
            return notRevealedUri;
        }

        string memory currentBaseURI = _baseURI();
        uint256 nftId = (tokenId + tokenOffset) % _cap;
        
        return bytes(currentBaseURI).length > 0
            ? string(abi.encodePacked(currentBaseURI, nftId.toString(), baseExtension))
            : "";
    }

    // external
    function getOwnershipData(uint256 tokenId)
    external
    view
    returns (TokenOwnership memory)
    {
        return _ownershipOf(tokenId);
    }

    //only owner
    function reveal(string memory _newBaseURI) public onlyOwner {
        require(!revealed, "already reveal!");

        setBaseURI(_newBaseURI);

        s_requestId = COORDINATOR.requestRandomWords(
            keyHash,
            s_subscriptionId,
            requestConfirmations,
            callbackGasLimit,
            numWords
        );
    }

    function setDevCap(uint256 _devCap) public onlyOwner {
        devCap = _devCap;
    }

    function setNotRevealUri(string memory _newNotRevealUri) public onlyOwner {
        notRevealedUri = _newNotRevealUri;
    }

    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }

    function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
        baseExtension = _newBaseExtension;
    }

    function pause(bool _state) public onlyOwner {
        paused = _state;
    }

    function setSaleContract(address _addr) public onlyOwner {
        saleContract = _addr;
    }

    function withdraw() public payable onlyOwner {
        (bool os, ) = payable(msg.sender).call{value: address(this).balance}("");
        
        require(os);
    }

    function fulfillRandomWords(
    uint256, /* requestId */
    uint256[] memory randomWords
    ) internal override {
        require(!revealed, "already reveal!");
        tokenOffset = (randomWords[0] % _cap);
        revealed = true;
    }

}