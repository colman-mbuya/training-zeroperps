// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {ZeroToken} from "../../src/ZeroToken.sol";
import {DeployZeroToken} from "../../script/DeployZeroToken.s.sol";
import {Test, console} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";

contract ZeroTokenTest is StdCheats, Test {
    ZeroToken zeroToken;

    function setUp() external {
        DeployZeroToken deployer = new DeployZeroToken();
        zeroToken = deployer.run();
    }

    function testTotalSupplyIsNotNegative() public {
        uint256 totalSupply = zeroToken.totalSupply();
        uint256 expectedSupply = 0;
        assertEq(totalSupply, expectedSupply);
    }
}