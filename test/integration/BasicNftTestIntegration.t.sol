// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console2} from "forge-std/Test.sol";
import {BasicNft} from "../../src/BasicNft.sol";
import {DeployBasicNft} from "../../script/DeployBasicNft.s.sol";

contract BasicNftIntegrationTest is Test {
    DeployBasicNft deployer;
    BasicNft basicNft;
    address public USER = makeAddr("user");
    string constant NFT_URL =
        "ipfs://QmdJ6UgvvFZ35ZCykUHUf6L7z4mXV71jNnDJcBDdT7c7mY";

    function setUp() public {
        deployer = new DeployBasicNft();
        basicNft = deployer.run();
    }

    function testNameIsCorrect() public view {
        string memory expectName = "Dogies";
        string memory actualName = basicNft.name();
        assert(
            keccak256(abi.encode(expectName)) ==
                keccak256(abi.encode(actualName))
        );
        //assertEq(expectName, actualName);
    }

    function testCanMintAndHaveABalance() public {
        vm.prank(USER);
        basicNft.mintNft(NFT_URL);
        assertEq(basicNft.getTokenCounter(), 1);
        assertEq(basicNft.tokenURI(0), NFT_URL);
        assertEq(basicNft.balanceOf(USER), 1);
    }
}
