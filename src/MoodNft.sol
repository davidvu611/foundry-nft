// SPDX-License-Identifer: MIT
pragma solidity ^0.8.20;
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNft is ERC721 {
    error MoodNft__CantFlipMoodIfNotOwner();
    enum NftMood {
        HAPPY,
        SAD
    }
    mapping(uint256 tokenId => NftMood nftMood) private s_tokenIdToMood;
    uint256 private s_tokenCounter;
    string s_sadSvgImageUri;
    string s_happySvgImageUri;

    constructor(
        string memory sadSvgImageUrl,
        string memory happySvgImageUrl,
        string memory name,
        string memory symbol
    ) ERC721(name, symbol) {
        s_tokenCounter = 0;
        s_sadSvgImageUri = sadSvgImageUrl;
        s_happySvgImageUri = happySvgImageUrl;
    }

    function mintNft() public {
        s_tokenIdToMood[s_tokenCounter] = NftMood.HAPPY;
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenCounter = s_tokenCounter + 1;
    }

    function flipMood(uint256 tokenId) public {
        if (
            getApproved(tokenId) != msg.sender && ownerOf(tokenId) != msg.sender
        ) {
            revert MoodNft__CantFlipMoodIfNotOwner();
        }

        if (s_tokenIdToMood[tokenId] == NftMood.HAPPY) {
            s_tokenIdToMood[tokenId] = NftMood.SAD;
        } else {
            s_tokenIdToMood[tokenId] = NftMood.HAPPY;
        }
    }

    function _baseURI() internal view override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        string memory imageUrl;
        NftMood mood = s_tokenIdToMood[tokenId];
        if (mood == NftMood.HAPPY) imageUrl = s_happySvgImageUri;
        else imageUrl = s_sadSvgImageUri;

        return
            string(
                abi.encodePacked(
                    _baseURI(),
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"',
                                name(),
                                '", "description":"Mood NFT bla bla","attributes":["trait_type":"background","value":"Green"}],"image","',
                                imageUrl,
                                '"}'
                            )
                        )
                    )
                )
            );

        // {"image":"ipfs://QmYtzEJf2Wha1HQ4VewwDFgvXW1YGTqbxSN9kkH8mei6QA",
        // "name":"Test Canidae #1709",
        // "description":"Guardians of the wild and companions of humankind",
        // "attributes":[
        //     {"trait_type":"background","value":"Green"},
        //     {"trait_type":"body","value":"Blue"}
        //     ]}
    }

    function getTokenCounter() public view returns (uint256) {
        return s_tokenCounter;
    }

    function getTokenMood(uint tokenId) public view returns (NftMood) {
        return s_tokenIdToMood[tokenId];
    }
}
