// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC721, ERC721URIStorage, Ownable{
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

    constructor(address initialOwner)
        ERC721("MyToken", "MTK")
        Ownable(initialOwner)
    {
        setBaseURI("https://ipfs.io/ipfs/Qmd9nGXxxbQEDtypHDKGfFsBPZ6CdW9GeVJhfWjHGrUnGm");
        setNotRevealedURI("https://ipfs.io/ipfs/QmXeqeiCJNdnpZsvLLbh3PaPs5nSEpcP2xkhqcrDQhEioQ");
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    function safeMint(address to) public {
        require(number<MAX_SUPPLY,"sold out");
        require(_isSaleActive, "Sale must be active to mint");
        
        uint256 tokenId = number;
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

}
