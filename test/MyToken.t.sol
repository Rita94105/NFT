// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import "../src/MyToken.sol";

contract MyTokenTest is Test{
    MyToken public token;
    address user = makeAddr("user");

    function setUp() public {
        token = new MyToken(user);
    }

    function testMint() public{
        vm.startPrank(user);

        token.flipSaleActive();
        bool result = token._isSaleActive();
        assertEq(result,true,"open sale fail");

        token.safeMint(user);

        string memory closed = token.tokenURI(0);
        console.logString(closed);

        token.flipReveal();

        string memory opened = token.tokenURI(0);
        console.logString(opened);

        assertEq(opened,closed,"open success");
        vm.stopPrank();
    }
}