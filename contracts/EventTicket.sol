// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/**
 * @title EventTicket
 * @dev NFT-based event ticketing system with anti-fraud features
 */
contract EventTicket is ERC721, ERC721URIStorage, Ownable, ReentrancyGuard {
    using Counters for Counters.Counter;
    
    Counters.Counter private _tokenIdCounter;
    Counters.Counter private _eventIdCounter;
    
    struct Event {
        uint256 eventId;
        string name;
        string description;
        uint256 date;
        string venue;
        uint256 totalTickets;
        uint256 ticketsSold;
        uint256 ticketPrice;
        address organizer;
        bool isActive;
        uint256 maxTransferPrice;
        bool transferable;
    }
    
    struct Ticket {
        uint256 ticketId;
        uint256 eventId;
        address originalBuyer;
        bool isUsed;
        uint256 seatNumber;
        string qrCode;
    }
    
    mapping(uint256 => Event) public events;
    mapping(uint256 => Ticket) public tickets;
    mapping(uint256 => bool) public verifiedTickets;
    
    event EventCreated(uint256 indexed eventId, string name, address organizer);
    event TicketMinted(uint256 indexed ticketId, uint256 indexed eventId, address buyer);
    event TicketVerified(uint256 indexed ticketId, address verifier);
    event TicketTransferred(uint256 indexed ticketId, address from, address to);
    
    constructor() ERC721("EventTicket", "ETKT") {}
    
    /**
     * @dev Create a new event
     * @param _name Event name
     * @param _description Event description
     * @param _date Event date (timestamp)
     * @param _venue Event venue
     * @param _totalTickets Total number of tickets
     * @param _ticketPrice Price per ticket in wei
     * @param _maxTransferPrice Maximum resale price
     * @param _transferable Whether tickets can be transferred
     */
    function createEvent(
        string memory _name,
        string memory _description,
        uint256 _date,
        string memory _venue,
        uint256 _totalTickets,
        uint256 _ticketPrice,
        uint256 _maxTransferPrice,
        bool _transferable
    ) external returns (uint256) {
        _eventIdCounter.increment();
        uint256 eventId = _eventIdCounter.current();
        
        events[eventId] = Event({
            eventId: eventId,
            name: _name,
            description: _description,
            date: _date,
            venue: _venue,
            totalTickets: _totalTickets,
            ticketsSold: 0,
            ticketPrice: _ticketPrice,
            organizer: msg.sender,
            isActive: true,
            maxTransferPrice: _maxTransferPrice,
            transferable: _transferable
        });
        
        emit EventCreated(eventId, _name, msg.sender);
        return eventId;
    }
    
    /**
     * @dev Mint a ticket for an event
     * @param _eventId Event ID
     * @param _seatNumber Seat number
     * @param _qrCode QR code for verification
     */
    function mintTicket(
        uint256 _eventId,
        uint256 _seatNumber,
        string memory _qrCode
    ) external payable nonReentrant returns (uint256) {
        Event storage eventData = events[_eventId];
        require(eventData.isActive, "Event not active");
        require(eventData.ticketsSold < eventData.totalTickets, "Sold out");
        require(msg.value >= eventData.ticketPrice, "Insufficient payment");
        
        _tokenIdCounter.increment();
        uint256 ticketId = _tokenIdCounter.current();
        
        tickets[ticketId] = Ticket({
            ticketId: ticketId,
            eventId: _eventId,
            originalBuyer: msg.sender,
            isUsed: false,
            seatNumber: _seatNumber,
            qrCode: _qrCode
        });
        
        eventData.ticketsSold++;
        _safeMint(msg.sender, ticketId);
        
        emit TicketMinted(ticketId, _eventId, msg.sender);
        return ticketId;
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
    
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId,
        uint256 batchSize
    ) internal override {
        if (from != address(0) && to != address(0)) {
            uint256 eventId = tickets[tokenId].eventId;
            require(events[eventId].transferable, "Ticket not transferable");
        }
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
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