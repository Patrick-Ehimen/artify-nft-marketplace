// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/**
 * @title IERC721
 * @dev Interface for the ERC721 standard
 */
interface IERC721{
    /**
     * @dev Transfers an NFT from one address to another.
     * @param _from The address of the current owner.
     * @param _to The address of the new owner.
     * @param _nftId The ID of the NFT to be transferred.
     */
    function transferFrom(
        address _from,
        address _to,
        uint256 _nftId
    ) external;
}

/**
 * @title NftAuction
 * @dev A contract for auctioning NFTs.
 */
contract NftAuction{
    /**
     * @dev The duration of the auction in seconds.
     */
    uint256 private constant DURATION = 7 days;

    /**
     * @dev The interface for the NFT contract.
     */
    IERC721 public  nft;
    /**
     * @dev The ID of the NFT being auctioned.
     */
    uint256 public  nftId;

    /**
     * @dev The address of the seller.
     */
    address payable public  seller;
    /**
     * @dev The starting price of the NFT.
     */
    uint256 public  startingPrice;
    /**
     * @dev The discount rate per second.
     */
    uint256 public  discountRate;
    /**
     * @dev The timestamp when the auction starts.
     */
    uint256 public  startAt;
    /**
     * @dev The timestamp when the auction expires.
     */
    uint256 public  expiresAt;
 

  /**
   * @dev Initializes the contract with the given parameters.
   * @param _startingPrice The starting price of the NFT.
   * @param _discountRate The discount rate per second.
   * @param _nft The address of the NFT contract.
   * @param _nftId The ID of the NFT being auctioned.
   */
  constructor(
    uint256 _startingPrice,
    uint256 _discountRate,
    address _nft,
    uint256 _nftId
  ) {
     seller = payable(msg.sender);
     startingPrice = _startingPrice;
     discountRate = _discountRate;
     startAt = block.timestamp;
     expiresAt = block.timestamp + DURATION;

     require(_startingPrice >= _discountRate + DURATION, "Starting price is too low");

     nft = IERC721(_nft);
     nftId = _nftId;
  }

  /**
   * @dev Calculates the current price of the NFT based on the discount rate and time elapsed.
   * @return The current price of the NFT.
   */
  function getPrice() public view returns(uint256){
    uint256 timeElapsed = block.timestamp - startAt;
    uint256 discount = discountRate * timeElapsed;

    return startingPrice - discount;
  }

  /**
   * @dev Allows a buyer to purchase the NFT.
   */
  function buy() external payable{
    require(block.timestamp < expiresAt, "This nft bidding has ended");

    uint256 price = getPrice();
    require(msg.value >= price, "The amount of ETH send is less then the price of Token");

    nft.transferFrom(seller, msg.sender, nftId);
    
    uint256 refund = msg.value - price;

    if(refund > 0){
        payable(msg.sender).transfer(refund);
    }
    selfdestruct(seller);
  }
}