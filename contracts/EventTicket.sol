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
    
    struct Event {
        uint256 eventId;
        string name;
        uint256 date;
        string venue;
        uint256 totalTickets;
        uint256 ticketsSold;
        uint256 ticketPrice;
        address organizer;
        bool isActive;
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
    
    event EventCreated(uint256 indexed eventId, string name, address organizer);
    event TicketMinted(uint256 indexed ticketId, uint256 indexed eventId, address buyer);
    
    constructor() ERC721("EventTicket", "ETKT") {}
    
    /**
     * @dev Create a new event
     * @param _name Event name
     * @param _date Event date (timestamp)
     * @param _venue Event venue
     * @param _totalTickets Total number of tickets
     * @param _ticketPrice Price per ticket in wei
     */
    function createEvent(
        string memory _name,
        uint256 _date,
        string memory _venue,
        uint256 _totalTickets,
        uint256 _ticketPrice
    ) external returns (uint256) {
        _eventIds.increment();
        uint256 eventId = _eventIds.current();
        
        events[eventId] = Event({
            eventId: eventId,
            name: _name,
            date: _date,
            venue: _venue,
            totalTickets: _totalTickets,
            ticketsSold: 0,
            ticketPrice: _ticketPrice,
            organizer: msg.sender,
            isActive: true
        });
        
        emit EventCreated(eventId, _name, msg.sender);
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
        require(eventData.ticketsSold < eventData.totalTickets, "Sold out");
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
     * @dev Mint a new ticket NFT
     * @param to Address to mint the ticket to
     * @return tokenId The ID of the minted token
     */
    function mint(address to) external onlyOwner returns (uint256) {
        _tokenIds.increment();
        uint256 tokenId = _tokenIds.current();
        _mint(to, tokenId);
        return tokenId;
    }
    
    /**
     * @dev Get the total number of tokens minted
     */
    function totalSupply() external view returns (uint256) {
        return _tokenIds.current();
    }
}