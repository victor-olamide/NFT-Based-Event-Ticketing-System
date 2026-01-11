// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/**
 * @title EventTicket
 * @dev ERC721 NFT contract for event tickets with Base network optimization
 * Optimized for low gas costs and fast transactions on Base L2
 */
contract EventTicket is ERC721, ERC721URIStorage, Ownable, ReentrancyGuard {
    using Counters for Counters.Counter;
    
    Counters.Counter private _tokenIds;
    Counters.Counter private _eventIds;
    
    enum TransferRestriction {
        NONE,
        ORGANIZER_ONLY,
        NO_TRANSFER
    }
    
    struct Event {
        uint256 eventId;
        string name;
        uint256 date;
        string venue;
        uint256 maxSupply;
        uint256 ticketsSold;
        uint256 ticketPrice;
        address organizer;
        bool isActive;
        TransferRestriction transferRestriction;
        uint256 maxResalePrice;
    }
    
    struct Ticket {
        uint256 ticketId;
        uint256 eventId;
        address originalBuyer;
        bool isUsed;
        uint256 seatNumber;
    }
    
    mapping(uint256 => Event) public events;
    mapping(uint256 => Ticket) public tickets;
    mapping(uint256 => bool) public verifiedTickets;
    
    event EventCreated(
        uint256 indexed eventId, 
        string name, 
        address indexed organizer,
        uint256 maxSupply,
        TransferRestriction transferRestriction
    );
    event TicketMinted(uint256 indexed ticketId, uint256 indexed eventId, address buyer);
    event TicketVerified(uint256 indexed ticketId, address verifier);
    
    constructor() ERC721("EventTicket", "ETKT") {}
    
    /**
     * @dev Create a new event with Base network gas optimization
     * @param _name Event name
     * @param _date Event date (timestamp)
     * @param _venue Event venue
     * @param _ticketPrice Price per ticket in wei
     * @param _maxSupply Maximum number of tickets
     * @param _transferRestriction Transfer restriction level
     */
    function createEvent(
        string calldata _name,
        uint256 _date,
        string calldata _venue,
        uint256 _ticketPrice,
        uint256 _maxSupply,
        TransferRestriction _transferRestriction
    ) external returns (uint256) {
        require(bytes(_name).length > 0 && bytes(_name).length <= 100, "Invalid name length");
        require(_date > block.timestamp, "Invalid date");
        require(bytes(_venue).length > 0 && bytes(_venue).length <= 200, "Invalid venue length");
        require(_maxSupply > 0 && _maxSupply <= 100000, "Invalid max supply");
        require(_ticketPrice > 0, "Price must be positive");
        
        _eventIds.increment();
        uint256 eventId = _eventIds.current();
        
        events[eventId] = Event({
            eventId: eventId,
            name: _name,
            date: _date,
            venue: _venue,
            maxSupply: _maxSupply,
            ticketsSold: 0,
            ticketPrice: _ticketPrice,
            organizer: msg.sender,
            isActive: true,
            transferRestriction: _transferRestriction,
            maxResalePrice: _ticketPrice * 2
        });
        
        emit EventCreated(eventId, _name, msg.sender, _maxSupply, _transferRestriction);
        return eventId;
    }
    
    /**
     * @dev Mint a ticket for an event
     * @param _eventId Event ID
     * @param _seatNumber Seat number
     */
    function mintTicket(
        uint256 _eventId,
        uint256 _seatNumber
    ) external payable nonReentrant returns (uint256) {
        Event storage eventData = events[_eventId];
        require(eventData.isActive, "Event not active");
        require(eventData.ticketsSold < eventData.maxSupply, "Sold out");
        require(msg.value >= eventData.ticketPrice, "Insufficient payment");
        
        _tokenIds.increment();
        uint256 tokenId = _tokenIds.current();
        
        tickets[tokenId] = Ticket({
            ticketId: tokenId,
            eventId: _eventId,
            originalBuyer: msg.sender,
            isUsed: false,
            seatNumber: _seatNumber
        });
        
        eventData.ticketsSold++;
        _mint(msg.sender, tokenId);
        
        emit TicketMinted(tokenId, _eventId, msg.sender);
        return tokenId;
    }
    
    /**
     * @dev Validate transfer based on event restrictions
     * @param tokenId Token ID to validate
     * @param from Current owner
     * @param to New owner
     */
    function _validateTransfer(uint256 tokenId, address from, address to) internal view {
        Ticket memory ticket = tickets[tokenId];
        Event memory eventData = events[ticket.eventId];
        
        if (eventData.transferRestriction == TransferRestriction.NO_TRANSFER) {
            require(from == address(0), "Transfer not allowed");
        } else if (eventData.transferRestriction == TransferRestriction.ORGANIZER_ONLY) {
            require(to == eventData.organizer || from == address(0), "Only organizer transfers");
        }
    }
    
    /**
     * @dev Set token URI for metadata
     * @param tokenId Token ID
     * @param _tokenURI Metadata URI
     */
    function setTokenURI(uint256 tokenId, string memory _tokenURI) external onlyOwner {
        _setTokenURI(tokenId, _tokenURI);
    }
    
    /**
     * @dev Get total supply of tokens
     */
    function totalSupply() external view returns (uint256) {
        return _tokenIds.current();
    }
    
    /**
     * @dev Get total number of events
     */
    function totalEvents() external view returns (uint256) {
        return _eventIds.current();
    }
    
    /**
     * @dev Verify ticket at venue
     * @param _ticketId Ticket ID to verify
     */
    function verifyTicket(uint256 _ticketId) external returns (bool) {
        require(_exists(_ticketId), "Ticket does not exist");
        require(!tickets[_ticketId].isUsed, "Ticket already used");
        
        tickets[_ticketId].isUsed = true;
        verifiedTickets[_ticketId] = true;
        
        emit TicketVerified(_ticketId, msg.sender);
        return true;
    }
    
    /**
     * @dev Create multiple events in batch for gas optimization
     * @param _names Array of event names
     * @param _dates Array of event dates
     * @param _venues Array of event venues
     * @param _ticketPrices Array of ticket prices
     * @param _maxSupplies Array of max supplies
     * @param _transferRestrictions Array of transfer restrictions
     */
    function createEventsBatch(
        string[] calldata _names,
        uint256[] calldata _dates,
        string[] calldata _venues,
        uint256[] calldata _ticketPrices,
        uint256[] calldata _maxSupplies,
        TransferRestriction[] calldata _transferRestrictions
    ) external returns (uint256[] memory) {
        uint256 length = _names.length;
        require(length > 0 && length <= 10, "Invalid batch size");
        require(
            _dates.length == length &&
            _venues.length == length &&
            _ticketPrices.length == length &&
            _maxSupplies.length == length &&
            _transferRestrictions.length == length,
            "Array length mismatch"
        );
        
        uint256[] memory eventIds = new uint256[](length);
        
        for (uint256 i = 0; i < length; i++) {
            eventIds[i] = createEvent(
                _names[i],
                _dates[i],
                _venues[i],
                _ticketPrices[i],
                _maxSupplies[i],
                _transferRestrictions[i]
            );
        }
        
        return eventIds;
    }
    
    /**
     * @dev Update max resale price for an event (organizer only)
     * @param _eventId Event ID
     * @param _maxResalePrice New maximum resale price
     */
    function updateMaxResalePrice(uint256 _eventId, uint256 _maxResalePrice) external {
        require(events[_eventId].organizer == msg.sender, "Not organizer");
        require(_maxResalePrice >= events[_eventId].ticketPrice, "Below original price");
        events[_eventId].maxResalePrice = _maxResalePrice;
    }
    
    /**
     * @dev Deactivate an event (only organizer)
     * @param _eventId Event ID to deactivate
     */
    function deactivateEvent(uint256 _eventId) external {
        require(events[_eventId].organizer == msg.sender, "Not organizer");
        events[_eventId].isActive = false;
    }
    
    /**
     * @dev Get event details
     * @param _eventId Event ID
     */
    function getEvent(uint256 _eventId) external view returns (Event memory) {
        return events[_eventId];
    }
    
    /**
     * @dev Get ticket details
     * @param _ticketId Ticket ID
     */
    function getTicket(uint256 _ticketId) external view returns (Ticket memory) {
        return tickets[_ticketId];
    }
    
    /**
     * @dev Withdraw contract balance (only owner)
     */
    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");
        payable(owner()).transfer(balance);
    }
    
    // Required overrides for ERC721URIStorage
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId,
        uint256 batchSize
    ) internal override {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
        if (from != address(0)) {
            _validateTransfer(tokenId, from, to);
        }
    }
    
    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }
    
    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }
    
    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721URIStorage) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}