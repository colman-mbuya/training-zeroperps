// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {ZeroPerps} from "../src/ZeroPerps.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DeployZeroPerps is Script {
    ERC20 private underyling = new ERC20Mock();

    function run() external returns (ZeroPerps) {
        vm.startBroadcast();
        ZeroPerps zeroPerps = new ZeroPerps(underyling);
        vm.stopBroadcast();
        return zeroPerps;
    }
}