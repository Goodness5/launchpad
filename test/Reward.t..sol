// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../lib/forge-std/src/Test.sol";
import "../src/reward.sol";
import "../src/token.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";


contract CounterTest is Test {
    Launch launch;
    Launchtoken token;
    address tester1 = mkaddr("tester1");
    address tester2 = mkaddr("tester2");

    function setUp() public {
        vm.startPrank(tester1);
        token = new Launchtoken();
        launch = new Launch();
        vm.stopPrank();
    }

function testAddReward() public {
    address tokenaddr = address(token);
    address launchaddr = address(launch);
    vm.startPrank(tester1);
    vm.deal(tester1, 100000 ether);
    token.approve(launchaddr, 100); // Add approval step
    launch.AddReward(tokenaddr, 10, 100, 9999999, tester1);
}


     function mkaddr(string memory name) public returns (address) {
        address addr = address(
            uint160(uint256(keccak256(abi.encodePacked(name))))
        );
        vm.label(addr, name);
        return addr;
    }
}
