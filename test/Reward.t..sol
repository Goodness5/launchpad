// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../lib/forge-std/src/Test.sol";
import "../src/reward.sol";
import "../src/token.sol";


contract CounterTest is Test {
    Launch launch;
    Launchtoken token;
    address tester1 = mkaddr("tester1");

    function setUp() public {
        vm.startPrank(tester1);
        token = new Launchtoken();
        launch = new Launch(address(token), "Launch", 20);
        vm.stopPrank();
    }

    function testAddReward() public{

    }

     function mkaddr(string memory name) public returns (address) {
        address addr = address(
            uint160(uint256(keccak256(abi.encodePacked(name))))
        );
        vm.label(addr, name);
        return addr;
    }
}
