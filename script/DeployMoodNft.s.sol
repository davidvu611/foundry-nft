//SPDX-License-Identifer: MIT
pragma solidity ^0.8.18;
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";
import {Script} from "forge-std/Script.sol";
import {console2} from "forge-std/Test.sol";
import {MoodNft} from "../src/MoodNft.sol";

contract DeployMoodNft is Script {
    MoodNft moodNft;

    function run() public returns (MoodNft) {
        string memory svgHappyImageUri = svgToImageUri(
            vm.readFile("./images/happy.svg")
        );
        string memory svgSadImageUri = svgToImageUri(
            vm.readFile("./images/sad.svg")
        );
        vm.startBroadcast();
        moodNft = new MoodNft(
            svgSadImageUri,
            svgHappyImageUri,
            "MNFT",
            "Mood NFT"
        );
        vm.stopBroadcast();
        return moodNft;
    }

    function svgToImageUri(
        string memory svg
    ) public pure returns (string memory) {
        return
            string(
                abi.encodePacked(
                    "data:image/svg+xml;base64,",
                    Base64.encode(bytes(svg))
                )
            );
    }
}
