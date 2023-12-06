// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {IPyth} from "@pyth-sdk-solidity/Ipyth.sol";
import {PythStructs} from "@pyth-sdk-solidity/PythStructs.sol";

contract PythBtcPrice is Script {

    function convertToUint(PythStructs.Price memory price, uint8 targetDecimals) private pure returns (uint256) {
        if (price.price < 0 || price.expo > 0 || price.expo < -255) {
            revert();
        }

        uint8 priceDecimals = uint8(uint32(-1 * price.expo));

        if (targetDecimals >= priceDecimals) {
            return
                uint(uint64(price.price)) *
                10 ** uint32(targetDecimals - priceDecimals);
        } else {
            return
                uint(uint64(price.price)) /
                10 ** uint32(priceDecimals - targetDecimals);
        }
    }

    function getBtcPrice(HelperConfig config) public {
        address pythAddr = config.getSepoliaEthConfig().priceFeed;
        bytes32 btcPriceId = config.getSepoliaEthConfig().priceId;
        vm.startBroadcast();
        // We can probably use this with an age of 20 minutes (1200 secs), and we should be fine
        // PythStructs.Price memory btcPrice = IPyth(pythAddr).getPriceNoOlderThan(btcPriceId, 180);
        PythStructs.Price memory btcPrice = IPyth(pythAddr).getPrice(btcPriceId);
        vm.stopBroadcast();
        console.log("Got %i price", convertToUint(btcPrice, 18));
    }

    function run() external {
        HelperConfig helper_config = new HelperConfig();
        getBtcPrice(helper_config);
    }
}