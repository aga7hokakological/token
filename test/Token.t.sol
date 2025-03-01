// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {UpgradeableToken} from "../src/UpgradeableToken.sol";
import {UpgradeableToken2} from "../src/UpgradeableToken2.sol";

import {Upgrades} from "openzeppelin-foundry-upgrades/Upgrades.sol";

contract TokenTest is Test {
    address owner = makeAddr("owner");

    address proxy;
    address proxy2;
    address user1 = makeAddr("user1");
    address user2 = makeAddr("user2");

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
            abi.encodeCall(UpgradeableToken2.initialize, ("Token", "TOKEN", address(0)))
        );

        proxy2 = Upgrades.getImplementationAddress(proxy);
    }

    function testTokens() public {
        assertEq(token.totalSupply(), 300000000 ether);
    }

    function testBlackList() public {
        token2 = UpgradeableToken2(proxy2);

        bool yes = token2.isBlacklisted(user1);
        console.log("blacklisted::", yes);
    }
}