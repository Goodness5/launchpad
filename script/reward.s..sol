// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../lib/forge-std/src/Script.sol";
import "../src/reward.sol";
import "../src/token.sol";

contract RewardScript is Script {
    Launcher launch;
    Launchtoken token;

    function run() public {
        token = new Launchtoken();
        launch = new Launcher();
    }

}
