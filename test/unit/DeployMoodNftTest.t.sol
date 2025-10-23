// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console2} from "forge-std/Test.sol";
import {DeployMoodNft} from "../../script/DeployMoodNft.s.sol";
import {MoodNft} from "../../src/MoodNft.sol";

contract DeployMoodNftTest is Test {
    DeployMoodNft deployer;
    MoodNft moodNft;

    function setUp() public {
        deployer = new DeployMoodNft();
        moodNft = deployer.run();
        console2.log(moodNft.tokenURI(0));
    }
}
