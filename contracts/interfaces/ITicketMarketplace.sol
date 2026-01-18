// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title ITicketMarketplace
 * @dev Interface for TicketMarketplace contract
 */
interface ITicketMarketplace {
    
    struct Listing {
        uint256 tokenId;
        address seller;
        uint256 price;
        bool active;
        uint256 listedAt;
    }
    
    struct RoyaltyInfo {
        address recipient;
        uint96 royaltyFraction;
    }
    
    event TicketListed(uint256 indexed listingId, uint256 indexed tokenId, address seller, uint256 price);
    event TicketSold(uint256 indexed listingId, uint256 indexed tokenId, address buyer, uint256 price);
    event ListingCancelled(uint256 indexed listingId, uint256 indexed tokenId);
    event RoyaltySet(address indexed collection, address recipient, uint96 royaltyFraction);
    
    function listTicket(uint256 _tokenId, uint256 _price) external returns (uint256);
    
    function buyTicket(uint256 _listingId) external payable;
    
    function cancelListing(uint256 _listingId) external;
    
    function setRoyaltyInfo(
        address _collection,
        address _recipient,
        uint96 _royaltyFraction
    ) external;
    
    function setPlatformFee(uint256 _newFee) external;
    
    function getListing(uint256 _listingId) external view returns (Listing memory);
    
    function isTokenListed(uint256 _tokenId) external view returns (bool);
}