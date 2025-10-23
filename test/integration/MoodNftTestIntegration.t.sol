// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console2} from "forge-std/Test.sol";
import {DeployMoodNft} from "../../script/DeployMoodNft.s.sol";
import {MoodNft} from "../../src/MoodNft.sol";

contract MoodNftIntegrationTest is Test {
    DeployMoodNft deplopyer;
    MoodNft moodNft;
    address USER = makeAddr("user");

    function setUp() public {
        deplopyer = new DeployMoodNft();
        moodNft = deplopyer.run();
    }

    function testViewTokenUriIntegration() public {
        vm.prank(USER);
        moodNft.mintNft();
        console2.log(moodNft.tokenURI(0));
    }

    function testFlipTokenToSad() public {
        vm.prank(USER);
        moodNft.mintNft();
        // console2.log("Happy", moodNft.tokenURI(0));
        // console2.log("Happy", uint(moodNft.getTokenMood(0)));

        vm.prank(USER);
        moodNft.flipMood(0);
        // console2.log("Sad", moodNft.tokenURI(0));
        // console2.log("Sad", uint(moodNft.getTokenMood(0)));
        assert(moodNft.getTokenMood(0) == MoodNft.NftMood.SAD);
    }
}
