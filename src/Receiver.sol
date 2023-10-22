// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract NotUseful is ERC721 {
    string baseURI="https://ipfs.io/ipfs/QmWQz1aP82A7W3Ljw5YbftQ1fydiYo84Qku1a4QjnWiYRk";

    constructor(address to) ERC721("Not Useful NFT", "NoNFT") {
        _safeMint(to,0);
    }

    function tokenURI(uint256)
        public
        view
        override 
        returns (string memory)
    {
        return baseURI;
    }
}

contract HW_Token is ERC721, ERC721URIStorage {
    string private uri = "https://ipfs.io/ipfs/QmY7thStU1X7nTgEFJLdeLoZgnn3cQZCaHT6fiESSpQRN7";
    uint256 private _nextTokenId;

    // 1. with name and symbol
    constructor() ERC721("Homework NFT", "HWNFT") {}

    // 2. mint function
    function mint(address to) public {
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
    }


    function tokenURI(uint256) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        // 3. return same metadata
        return uri;
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}

contract NFTReceiver is IERC721Receiver {
    address private HWNFT;

    constructor(address _HWNFT) {
        HWNFT = _HWNFT;
    }

    function onERC721Received(
        address operator,
        address ,
        uint256 tokenId,
        bytes calldata
    ) public returns (bytes4) {
        // 1. check sender is not same as HW
        if(operator != HWNFT) {
            // 2. transfer NoUseful NFT back to original user
            IERC721(msg.sender).safeTransferFrom(address(this), operator, tokenId);
            // 3. mint HW NFT for original operator
            HW_Token(HWNFT).mint(operator);
        }
        return IERC721Receiver.onERC721Received.selector;
    }
}
