// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/interfaces/IERC2981.sol";

/**
 * @title TicketMarketplace
 * @dev Secondary marketplace for event tickets with royalty support
 */
contract TicketMarketplace is ReentrancyGuard, Ownable {
    
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
    
    mapping(uint256 => Listing) public listings;
    mapping(address => RoyaltyInfo) public royalties;
    mapping(uint256 => uint256) public listingIds;
    
    uint256 private _listingIdCounter;
    uint256 public platformFee = 250; // 2.5%
    address public feeRecipient;
    
    IERC721 public ticketContract;
    
    event TicketListed(uint256 indexed listingId, uint256 indexed tokenId, address seller, uint256 price);
    event TicketSold(uint256 indexed listingId, uint256 indexed tokenId, address buyer, uint256 price);
    event ListingCancelled(uint256 indexed listingId, uint256 indexed tokenId);
    event RoyaltySet(address indexed collection, address recipient, uint96 royaltyFraction);
    
    constructor(address _ticketContract, address _feeRecipient) {
        ticketContract = IERC721(_ticketContract);
        feeRecipient = _feeRecipient;
    }
    
    /**
     * @dev List a ticket for sale
     * @param _tokenId Token ID to list
     * @param _price Sale price in wei
     */
    function listTicket(uint256 _tokenId, uint256 _price) external nonReentrant returns (uint256) {
        require(ticketContract.ownerOf(_tokenId) == msg.sender, "Not token owner");
        require(ticketContract.isApprovedForAll(msg.sender, address(this)) || 
                ticketContract.getApproved(_tokenId) == address(this), "Not approved");
        require(_price > 0, "Price must be greater than 0");
        
        _listingIdCounter++;
        uint256 listingId = _listingIdCounter;
        
        listings[listingId] = Listing({
            tokenId: _tokenId,
            seller: msg.sender,
            price: _price,
            active: true,
            listedAt: block.timestamp
        });
        
        listingIds[_tokenId] = listingId;
        
        emit TicketListed(listingId, _tokenId, msg.sender, _price);
        return listingId;
    }
    
    /**
     * @dev Buy a listed ticket
     * @param _listingId Listing ID to purchase
     */
    function buyTicket(uint256 _listingId) external payable nonReentrant {
        Listing storage listing = listings[_listingId];
        require(listing.active, "Listing not active");
        require(msg.value >= listing.price, "Insufficient payment");
        require(msg.sender != listing.seller, "Cannot buy own listing");
        
        listing.active = false;
        
        uint256 totalPrice = listing.price;
        uint256 platformFeeAmount = (totalPrice * platformFee) / 10000;
        uint256 royaltyAmount = 0;
        
        // Calculate royalty
        RoyaltyInfo memory royaltyInfo = royalties[address(ticketContract)];
        if (royaltyInfo.recipient != address(0)) {
            royaltyAmount = (totalPrice * royaltyInfo.royaltyFraction) / 10000;
        }
        
        uint256 sellerAmount = totalPrice - platformFeeAmount - royaltyAmount;
        
        // Transfer ticket
        ticketContract.safeTransferFrom(listing.seller, msg.sender, listing.tokenId);
        
        // Transfer payments
        if (platformFeeAmount > 0) {
            payable(feeRecipient).transfer(platformFeeAmount);
        }
        if (royaltyAmount > 0) {
            payable(royaltyInfo.recipient).transfer(royaltyAmount);
        }
        payable(listing.seller).transfer(sellerAmount);
        
        // Refund excess payment
        if (msg.value > totalPrice) {
            payable(msg.sender).transfer(msg.value - totalPrice);
        }
        
        emit TicketSold(_listingId, listing.tokenId, msg.sender, totalPrice);
    }
    
    /**
     * @dev Cancel a listing
     * @param _listingId Listing ID to cancel
     */
    function cancelListing(uint256 _listingId) external {
        Listing storage listing = listings[_listingId];
        require(listing.seller == msg.sender || msg.sender == owner(), "Not authorized");
        require(listing.active, "Listing not active");
        
        listing.active = false;
        
        emit ListingCancelled(_listingId, listing.tokenId);
    }
    
    /**
     * @dev Set royalty information for a collection
     * @param _collection Collection address
     * @param _recipient Royalty recipient
     * @param _royaltyFraction Royalty fraction (basis points)
     */
    function setRoyaltyInfo(
        address _collection,
        address _recipient,
        uint96 _royaltyFraction
    ) external onlyOwner {
        require(_royaltyFraction <= 1000, "Royalty too high"); // Max 10%
        
        royalties[_collection] = RoyaltyInfo({
            recipient: _recipient,
            royaltyFraction: _royaltyFraction
        });
        
        emit RoyaltySet(_collection, _recipient, _royaltyFraction);
    }
    
    /**
     * @dev Update platform fee
     * @param _newFee New platform fee (basis points)
     */
    function setPlatformFee(uint256 _newFee) external onlyOwner {
        require(_newFee <= 1000, "Fee too high"); // Max 10%
        platformFee = _newFee;
    }
    
    /**
     * @dev Get listing details
     * @param _listingId Listing ID
     */
    function getListing(uint256 _listingId) external view returns (Listing memory) {
        return listings[_listingId];
    }
    
    /**
     * @dev Check if token is listed
     * @param _tokenId Token ID
     */
    function isTokenListed(uint256 _tokenId) external view returns (bool) {
        uint256 listingId = listingIds[_tokenId];
        return listingId > 0 && listings[listingId].active;
    }
}