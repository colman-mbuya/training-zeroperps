// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {ZeroPerps} from "../../src/ZeroPerps.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC4626} from "@openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol";

contract ZeroPerpsHarness is ZeroPerps {
    constructor(ERC20 _asset, address _pythAddr, bytes32 _btcPriceId) ZeroPerps(_asset, _pythAddr, _btcPriceId) { }

    function getLatestBtcPrice(bytes[] memory updateData) public payable returns (uint256) {
        return _getLatestBtcPrice(updateData);
     }
}