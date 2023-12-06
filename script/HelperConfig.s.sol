// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {MockPyth} from "@pyth-sdk-solidity/MockPyth.sol";
import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

contract HelperConfig is Script {
    struct BtcPriceFeedConfig {
        address priceFeed;
        bytes32 priceId;
    }
    BtcPriceFeedConfig public activeBtcNetworkConfig;
    MockPyth public mockPyth;
    // Can be anything for mock Pyth
    bytes32 private constant PRICEID = 0x0000000000000000000000000000000000000000000000000000000000001234;

    constructor() {
        if (block.chainid == 11155111) {
            activeBtcNetworkConfig = getSepoliaEthConfig();
        } else {
            activeBtcNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (BtcPriceFeedConfig memory) {
        return BtcPriceFeedConfig({
            priceFeed: 0xDd24F84d36BF92C65F92307595335bdFab5Bbd21,
            priceId: 0xe62df6c8b4a85fe1a67db44dc12de5db330f7ac66b72dc658afedf0f4a415b43
        });
    }

    function getOrCreateAnvilEthConfig() public returns (BtcPriceFeedConfig memory) {
        // This to avoid creating the Mock Pyth contract again when running multiple tests
        if (activeBtcNetworkConfig.priceFeed != address(0)) {
            return activeBtcNetworkConfig;
        }
        vm.startBroadcast();
        mockPyth = new MockPyth(60, 1);
        vm.stopBroadcast();

        return BtcPriceFeedConfig({
            priceFeed: address(mockPyth),
            priceId: PRICEID
        });
    }

    function getPriceFeed() public view returns (address) {
        return activeBtcNetworkConfig.priceFeed;
    }

    function getPriceId() public view returns (bytes32) {
        return activeBtcNetworkConfig.priceId;
    }

    function getMockPyth() public view returns (MockPyth) {
        return mockPyth;
    }

}