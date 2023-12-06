// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {ZeroPerps} from "../src/ZeroPerps.sol";
import {DeployZeroPerps} from "../script/DeployZeroPerps.s.sol";
import {Test, console} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";

contract ZeroTokenTest is StdCheats, Test {
    ZeroPerps zeroPerps;
    ERC20Mock vault_asset_mock;
    ERC20 vault_asset;

    address public constant LP1 = address(1);
    uint256 public constant LP_AMOUNT = 5e18;

    function setUp() external {
        DeployZeroPerps deployer = new DeployZeroPerps();
        (zeroPerps, vault_asset_mock) = deployer.run_mock();
        vault_asset_mock.mint(LP1, 100e18);
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
}