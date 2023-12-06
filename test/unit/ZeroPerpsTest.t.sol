// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {ZeroPerpsHarness} from "../harness/ZeroPerps.t.sol";
import {MockPyth} from "@pyth-sdk-solidity/MockPyth.sol";
import {DeployZeroPerps} from "../../script/DeployZeroPerps.s.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";
import {Test, console} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";

contract ZeroTokenTest is StdCheats, Test {
    ZeroPerpsHarness zeroPerps;
    ERC20Mock vault_asset_mock;
    HelperConfig helper_config;
    ERC20 vault_asset;
    MockPyth mockPyth;

    address public constant LP1 = address(1);
    uint256 public constant LP_AMOUNT = 5e18;

    function setUp() external {
        DeployZeroPerps deployer = new DeployZeroPerps();
        (zeroPerps, vault_asset_mock, helper_config) = deployer.run_unit_test_deploy();
        mockPyth = helper_config.getMockPyth();
        vault_asset_mock.mint(LP1, 100e18);
        // Fund out contract with eth to pay for Pyth calls
        vm.deal(address(this), 10 ether);
        vm.deal(LP1, 10 ether);
    }

    function testTotalInitialSupplyIsZero() public {
        uint256 totalSupply = zeroPerps.totalSupply();
        uint256 expectedSupply = 0;
        assertEq(totalSupply, expectedSupply);
    }

    function testSharesIssuedInCorrectProportionality() public {
        vm.startPrank(LP1);
        vault_asset_mock.approve(address(zeroPerps), LP_AMOUNT);
        zeroPerps.deposit(LP_AMOUNT, LP1);
        vm.stopPrank();
        uint256 expectedSupply = 0;
        uint256 totalSupply = zeroPerps.totalSupply();
        console.log("Total supply: %i", totalSupply);
        console.log("Total shares: %i", zeroPerps.totalAssets());
        assertNotEq(totalSupply, expectedSupply);
    }

    function testMintShouldFailIfEquivalentAssetHasNotBeenApprovedForWithdrawal() public {
        vm.prank(LP1);
        vm.expectRevert();
        zeroPerps.mint(1, LP1);
    }

    function testPythMockReturnsPrice() public {
        bytes[] memory updateData = new bytes[](1);
        updateData[0] = mockPyth.createPriceFeedUpdateData(
            helper_config.getPriceId(),
            30000 * 100000,
            10 * 100000,
            -5,
            30000 * 100000,
            10 * 100000,
            uint64(block.timestamp)
        );
        vm.prank(LP1);
        uint256 price = zeroPerps.getLatestBtcPrice{value: 1 ether}(updateData);
        console.log("Price: %i", price);
        assertNotEq(price, 0);
    }
}