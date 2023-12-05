// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {ZeroPerps} from "../src/ZeroPerps.sol";
import {DeployZeroPerps} from "../script/DeployZeroPerps.s.sol";
import {Test, console} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";

contract ZeroTokenTest is StdCheats, Test {
    ZeroPerps zeroPerps;

    function setUp() external {
        DeployZeroPerps deployer = new DeployZeroPerps();
        zeroPerps = deployer.run();
    }

    function testTotalInitialSupplyIsZero() public {
        uint256 totalSupply = zeroPerps.totalSupply();
        uint256 expectedSupply = 0;
        assertEq(totalSupply, expectedSupply);
    }
}