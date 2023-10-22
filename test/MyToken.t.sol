// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import "../src/MyToken.sol";

contract MyTokenTest is Test{
    MyToken public token;
    address user = makeAddr("user");

    function setUp() public {
        vm.prank(user);
        token = new MyToken();
    }

    function testMint() public{
        vm.startPrank(user);

        token.flipSaleActive();
        bool result = token._isSaleActive();
        assertEq(result,true,"open sale fail");

        token.safeMint(user);

        string memory closed = token.tokenURI(0);
        assertEq(closed,"https://ipfs.io/ipfs/QmXeqeiCJNdnpZsvLLbh3PaPs5nSEpcP2xkhqcrDQhEioQ","default route error");

        token.flipReveal();

        string memory opened = token.tokenURI(0);
        assertEq(opened,"https://ipfs.io/ipfs/Qmd9nGXxxbQEDtypHDKGfFsBPZ6CdW9GeVJhfWjHGrUnGm","unblind fail");
        
        vm.stopPrank();
    }
}