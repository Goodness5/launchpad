// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../lib/forge-std/src/Test.sol";
import "../src/reward.sol";
import "../src/token.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";


contract CounterTest is Test {
    Launcher launcher;
    Launchtoken token;
    address tester1 = mkaddr("tester1");
    address tester2 = mkaddr("tester2");

    function setUp() public {
        vm.startPrank(tester1);
        token = new Launchtoken();
        launcher = new Launcher();
        vm.stopPrank();
    }

function testAddReward() public {
    address tokenaddr = address(token);
    address launchaddr = address(launcher);
    vm.prank(tokenaddr);
    IERC20(token).approve(address(launcher), 100000000); // Add approval step
    vm.startPrank(tester1);
    vm.deal(tester1, 100000 ether);
    launcher.AddReward(tokenaddr, 10, 100,1800, tester1);
    vm.stopPrank();
}


function testParticipate() public{
    testAddReward();
    vm.startPrank(tester2);
    vm.deal(tester2, 100);
    // msg.value = 100 ether;
    vm.deal(tester2, 100000 ether);
    launcher.participate{value: 100 ether}("Launch");
    launcher.getRewardNames();
    vm.warp(99999999999);
    launcher.getlaunchStatus("Launch");
    vm.stopPrank();

}

    function testendlaunch() public{
        testParticipate();
        vm.startPrank(tester1);
        vm.deal(tester1, 100000 ether);
        launcher.getlaunchStatus("Launch");
        launcher.endlaunch("Launch");
        vm.stopPrank();
    }

     function mkaddr(string memory name) public returns (address) {
        address addr = address(
            uint160(uint256(keccak256(abi.encodePacked(name))))
        );
        vm.label(addr, name);
        return addr;
    }
}
