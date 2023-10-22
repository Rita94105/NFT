// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import "../src/MyToken.sol";

contract MyTokenTest is Test{
    MyToken public token;
    address user = makeAddr("user");

    function setup() public {
        token = new MyToken(user);
    }

    function testMint() public{
        vm.startPrank(user);
        token.flipSaleActive();
        assertEq(token._isSaleActive,true,"open sale fail");
        //token.fulfillRandomWords();
        //assertEq(token.s_requestId>0,true,"not random");
        token.safeMint(user);
        string memory closed = token.tokenURI(0);
        //console2.log(closed);
        token.flipReveal();
        string memory opened = token.tokenURI(0);
        //console2.log(opened);
        assertEq(opened,closed,"open success");
    }
}