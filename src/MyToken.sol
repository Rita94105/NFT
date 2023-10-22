// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/vrf/VRFConsumerBaseV2.sol";

contract MyToken is ERC721, ERC721URIStorage, Ownable,VRFConsumerBaseV2 {
    uint256 private number;

    // Constants
    uint256 public constant MAX_SUPPLY = 500;
    uint256 public mintPrice = 0.3 ether;
    uint256 public maxBalance = 1;
    uint256 public maxMint = 1;

    bool public _isSaleActive = false;
    bool public _revealed = false;

    string baseURI;
    string public notRevealedUri;
    string public baseExtension = ".json";

    mapping(uint256 => string) private _tokenURIs;

    // chainlink variables
    VRFCoordinatorV2Interface immutable COORDINATOR;
    address vrfCoordinator = 0x8103B0A8A00be2DDC778e6e7eaa21791Cd364625;
    uint64 immutable s_subscriptionId =6268;
    bytes32 immutable keyHash = 0x474e34a077df58807dbe9c96d3c009b23b3c6d0cce433e59bbf5b34f823bc56c;
    uint32 constant callbackGasLimit = 100000;
    uint16 constant requestConfirmations = 3;
    uint32 constant numWords = 1;

    uint256[] public s_randomWords;
    uint256 public s_requestId;

    constructor(address initialOwner)
        ERC721("MyToken", "MTK")
        Ownable(initialOwner)
        VRFConsumerBaseV2(vrfCoordinator)
    {
        COORDINATOR = VRFCoordinatorV2Interface(vrfCoordinator);
        setBaseURI("https://ipfs.io/ipfs/Qmd9nGXxxbQEDtypHDKGfFsBPZ6CdW9GeVJhfWjHGrUnGm");
        setNotRevealedURI("https://ipfs.io/ipfs/QmXeqeiCJNdnpZsvLLbh3PaPs5nSEpcP2xkhqcrDQhEioQ");
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    function safeMint(address to) public {
        require(number<MAX_SUPPLY,"sold out");
        require(_isSaleActive, "Sale must be active to mint");

        uint256 tokenId = (number +s_randomWords[0])%MAX_SUPPLY;
        //uint256 tokenId = number;
        _safeMint(to, tokenId);
        number ++;
    }

    // The following functions are overrides required by Solidity.

    function tokenURI(uint256)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        if (_revealed == false) {
            return notRevealedUri;
        }else{
            return baseURI;
        }
    }

    function flipSaleActive() public onlyOwner {
        _isSaleActive = !_isSaleActive;
    }

    function flipReveal() public onlyOwner {
        _revealed = !_revealed;
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function setMintPrice(uint256 _mintPrice) public onlyOwner {
        mintPrice = _mintPrice;
    }

    function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
        notRevealedUri = _notRevealedURI;
    }

    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }

    function setBaseExtension(string memory _newBaseExtension)
        public
        onlyOwner
    {
        baseExtension = _newBaseExtension;
    }

    function setMaxBalance(uint256 _maxBalance) public onlyOwner {
        maxBalance = _maxBalance;
    }

    function setMaxMint(uint256 _maxMint) public onlyOwner {
        maxMint = _maxMint;
    }

    function fulfillRandomWords(
        uint256, 
        uint256[] memory randomWords
    ) internal override{
        s_randomWords = randomWords;
    }

    function requestRandomWords() external onlyOwner {
        // Will revert if subscription is not set and funded.
        s_requestId = COORDINATOR.requestRandomWords(
        keyHash,
        s_subscriptionId,
        requestConfirmations,
        callbackGasLimit,
        numWords
        );
    }

}
