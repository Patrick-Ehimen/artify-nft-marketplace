// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import "hardhat/console.sol";

contract NFTMarketplace is ERC721URIStorage {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;
    Counters.Counter private _itemsSold;

    uint256 listingPrice = 0.025 ether;
    address payable owner;

    /// @dev Mapping of token IDs to their corresponding MarketItem.
    mapping(uint256 => MarketItem) private idToMarketItem;

    struct MarketItem {
        uint256 tokenId;
        address payable seller;
        address payable owner;
        uint256 price;
        bool sold;
    }

    event MarketItemCreated(
        uint256 indexed tokenId,
        address seller,
        address owner,
        uint256 price,
        bool sold
    );

    /// @dev Modifier to check if the caller is the owner of the marketplace.
    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "only owner of the marketplace can change the listing price"
        );
        _;
    }

    constructor() ERC721("Metaverse Tokens", "METT") {
        owner = payable(msg.sender);
    }

    /**
     * @dev Updates the listing price of the marketplace.
     * @param _listingPrice The new listing price.
     */
    function updateListingPrice(
        uint256 _listingPrice
    ) public payable onlyOwner {
        require(
            owner == msg.sender,
            "Only marketplace owner can update listing price."
        );
        listingPrice = _listingPrice;
    }

    /**
     * @dev Creates a new token and lists it on the marketplace.
     * @param tokenURI The URI of the token.
     * @param price The price of the token.
     * @return The ID of the newly created token.
     */
    function createToken(
        string memory tokenURI,
        uint256 price
    ) public payable returns (uint256) {
        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();

        _mint(msg.sender, newTokenId);
        _setTokenURI(newTokenId, tokenURI);
        createMarketItem(newTokenId, price);
        return newTokenId;
    }

    /**
     * @dev Creates a new market item for the given token ID and price.
     * This function is private and can only be called by the contract itself.
     * It requires the price to be at least 1 wei and the message value to be equal to the listing price.
     * It transfers the token to the contract and emits a MarketItemCreated event.
     * @param tokenId The ID of the token to be listed.
     * @param price The price of the token.
     */
    function createMarketItem(uint256 tokenId, uint256 price) private {
        require(price > 0, "Price must be at least 1 wei");
        require(
            msg.value == listingPrice,
            "Price must be equal to listing price"
        );

        idToMarketItem[tokenId] = MarketItem(
            tokenId,
            payable(msg.sender),
            payable(address(this)),
            price,
            false
        );

        _transfer(msg.sender, address(this), tokenId);

        emit MarketItemCreated(
            tokenId,
            msg.sender,
            address(this),
            price,
            false
        );
    }

    /**
     * @dev Resells a token on the marketplace.
     * This function can only be called by the owner of the token.
     * It requires the message value to be equal to the listing price.
     * It updates the market item's price, sets the sold status to false, and transfers the token back to the contract.
     * @param tokenId The ID of the token to be resold.
     * @param price The new price of the token.
     */
    function resellToken(uint256 tokenId, uint256 price) public payable {
        require(
            idToMarketItem[tokenId].owner == msg.sender,
            "Only item owner can perform this operation"
        );
        require(
            msg.value == listingPrice,
            "Price must be equal to listing price"
        );
        idToMarketItem[tokenId].sold = false;
        idToMarketItem[tokenId].price = price;
        idToMarketItem[tokenId].seller = payable(msg.sender);
        idToMarketItem[tokenId].owner = payable(address(this));
        _itemsSold.decrement();

        _transfer(msg.sender, address(this), tokenId);
    }

    /**
     * @dev Creates a market sale for a token.
     * This function can only be called by the owner of the token.
     * It requires the message value to be equal to the price of the token.
     * It updates the owner of the token, sets the sold status to true, and increments the number of items sold.
     * It transfers the token to the buyer, transfers the listing price to the contract owner, and transfers the token price to the seller.
     * It sets the seller of the token to address(0).
     * @param tokenId The ID of the token to be sold.
     */
    function createMarketSale(uint256 tokenId) public payable {
        uint256 price = idToMarketItem[tokenId].price;
        require(
            msg.value == price,
            "Please submit the asking price in order to complete the purchase"
        );
        idToMarketItem[tokenId].owner = payable(msg.sender);
        idToMarketItem[tokenId].sold = true;
        _itemsSold.increment();

        _transfer(address(this), msg.sender, tokenId);
        payable(owner).transfer(listingPrice);
        payable(idToMarketItem[tokenId].seller).transfer(msg.value);

        idToMarketItem[tokenId].seller = payable(address(0));
    }

    /**
     * @dev Fetches all the market items.
     * This function returns an array of all the unsold market items.
     * @return An array of MarketItem.
     */
    function fetchMarketItems() public view returns (MarketItem[] memory) {
        uint256 itemCount = _tokenIds.current();
        uint256 unsoldItemCount = _tokenIds.current() - _itemsSold.current();
        uint256 currentIndex = 0;

        MarketItem[] memory items = new MarketItem[](unsoldItemCount);
        for (uint256 i = 0; i < itemCount; i++) {
            if (idToMarketItem[i + 1].owner == address(this)) {
                uint256 currentId = i + 1;
                MarketItem storage currentItem = idToMarketItem[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return items;
    }

    /**
     * @dev Fetches all the NFTs owned by the caller.
     * This function iterates through all the market items and returns an array of MarketItem structures
     * that represent the NFTs owned by the caller.
     * @return An array of MarketItem.
     */
    function fetchMyNFTs() public view returns (MarketItem[] memory) {
        uint256 totalItemCount = _tokenIds.current();
        uint256 itemCount = 0;
        uint256 currentIndex = 0;

        for (uint256 i = 0; i < totalItemCount; i++) {
            if (idToMarketItem[i + 1].owner == msg.sender) {
                itemCount += 1;
            }
        }

        // Initialize an array to store MarketItem structures for the caller's NFTs
        MarketItem[] memory items = new MarketItem[](itemCount);
        // Iterate through all market items to find those owned by the caller
        for (uint256 i = 0; i < totalItemCount; i++) {
            if (idToMarketItem[i + 1].owner == msg.sender) {
                // Calculate the current tokenId
                uint256 currentId = i + 1;
                // Retrieve the MarketItem structure for the current tokenId
                MarketItem storage currentItem = idToMarketItem[currentId];
                // Add the current item to the items array
                items[currentIndex] = currentItem;
                // Increment the index to keep track of the current position in the items array
                currentIndex += 1;
            }
        }
        return items;
    }

    /**
     * @dev Fetches all the NFTs listed by the caller.
     * This function iterates through all the market items and returns an array of MarketItem structures
     * that represent the NFTs listed by the caller.
     * @return An array of MarketItem.
     */
    function fetchItemsListed() public view returns (MarketItem[] memory) {
        uint256 totalItemCount = _tokenIds.current();
        uint256 itemCount = 0;
        uint256 currentIndex = 0;

        for (uint256 i = 0; i < totalItemCount; i++) {
            if (idToMarketItem[i + 1].seller == msg.sender) {
                itemCount += 1;
            }
        }

        MarketItem[] memory items = new MarketItem[](itemCount);
        for (uint256 i = 0; i < totalItemCount; i++) {
            if (idToMarketItem[i + 1].seller == msg.sender) {
                uint256 currentId = i + 1;
                MarketItem storage currentItem = idToMarketItem[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return items;
    }

    /**
     * Getter function
     */
    /* @dev Returns the listing price of the contract */
    function getListingPrice() public view returns (uint256) {
        return listingPrice;
    }
}
