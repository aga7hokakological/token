// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {UpgradeableToken} from "../src/UpgradeableToken.sol";
import {UpgradeableToken2} from "../src/UpgradeableToken2.sol";

import {Upgrades} from "openzeppelin-foundry-upgrades/Upgrades.sol";

contract TokenTest is Test {
    address owner = makeAddr("owner");

    address proxy;

    UpgradeableToken public token;
    UpgradeableToken2 public token2;

    function setUp() public {
        vm.startPrank(owner);
        proxy = Upgrades.deployUUPSProxy(
            "UpgradeableToken.sol",
            abi.encodeCall(UpgradeableToken.initialize, ("Token", "TOKEN", owner))
        );

        token = UpgradeableToken(proxy);
        vm.stopPrank();
    }

    function testOwner() public {
        assertEq(token.owner(), owner);
    }

    function testUpgradeability() public {
        vm.startPrank(owner);
        Upgrades.upgradeProxy(
            proxy,
            "UpgradeableToken2.sol",
            abi.encodeCall(UpgradeableToken2.initialize, ("Token", "TOKEN", owner))
        );
    }
}