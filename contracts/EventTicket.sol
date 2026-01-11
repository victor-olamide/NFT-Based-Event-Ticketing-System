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
        require(bytes(_name).length > 0, "Name required");
        require(_date > block.timestamp, "Invalid date");
        require(bytes(_venue).length > 0, "Venue required");
        require(_maxSupply > 0, "Max supply required");
        
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