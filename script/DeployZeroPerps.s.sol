// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {ZeroPerps} from "../src/ZeroPerps.sol";
import {ZeroPerpsHarness} from "../test/harness/ZeroPerps.t.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DeployZeroPerps is Script {

    function run_unit_test_deploy() external returns (ZeroPerpsHarness, ERC20Mock, HelperConfig) {
        HelperConfig helperConfig = new HelperConfig();
        address priceFeed = helperConfig.getPriceFeed();
        bytes32 priceId = helperConfig.getPriceId();

        vm.startBroadcast();
        ERC20Mock underyling = new ERC20Mock();
        ZeroPerpsHarness zeroPerps = new ZeroPerpsHarness(underyling, priceFeed, priceId);
        vm.stopBroadcast();
        return (zeroPerps, underyling, helperConfig);
    }

    // function run() external returns (ZeroPerps) {
    //     vm.startBroadcast();
    //     ZeroPerps zeroPerps = new ZeroPerps(underyling);
    //     vm.stopBroadcast();
    //     return (zeroPerps, underyling);
    // }
}