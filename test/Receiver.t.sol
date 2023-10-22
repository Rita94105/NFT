// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Test, console2} from "forge-std/Test.sol";
import "../src/Receiver.sol";

contract ReceiverTest is Test{
    NotUseful public nouse;
    HW_Token public hw;
    NFTReceiver public rec;
    address user = makeAddr("user");

    function setUp() public {
        nouse = new NotUseful(user);
        hw = new HW_Token();
        rec = new NFTReceiver(address(hw));
    }

    function testReceive() public{
        vm.startPrank(user);
        // confirm user own tokenID=0 NFT
        assertEq(nouse.ownerOf(0),user,"NFT 0 not belong to user");
        
        // approve to nouse contract to transfer
        nouse.approve(address(nouse), 0);
        address spender = nouse.getApproved(0);
        //confirm contract nouse get approvement
        assertEq(spender,address(nouse),"approve fail");
        
        //nouse contract transfer NFT to receiver contract
        nouse.safeTransferFrom(user,address(rec),0);
        //confirm nouse NFT turn back to user
        assertEq(nouse.ownerOf(0),user,"NFT not turn back to user");
        //confirm user get HW NFT
        assertEq(hw.ownerOf(0),user,"not mint hw to user");
        vm.stopPrank();
    }
}