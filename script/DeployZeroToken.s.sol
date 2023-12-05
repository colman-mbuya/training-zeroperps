// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {ZeroToken} from "../src/ZeroToken.sol";

contract DeployZeroToken is Script {
    function run() external returns (ZeroToken) {
        vm.startBroadcast();
        ZeroToken zeroToken = new ZeroToken();
        vm.stopBroadcast();
        return zeroToken;
    }
}