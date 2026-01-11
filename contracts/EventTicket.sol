// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract EventTicket is ERC721, Ownable, ReentrancyGuard {
    using Counters for Counters.Counter;
    
    Counters.Counter private _tokenIds;
    Counters.Counter private _eventIds;
    
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
    }
    
    struct Ticket {
        uint256 ticketId;
        uint256 eventId;
        address originalBuyer;
        bool isUsed;
        uint256 seatNumber;
        uint256 purchasePrice;
        uint256 purchaseTime;
    }
    
    mapping(uint256 => Event) public events;
    mapping(uint256 => Ticket) public tickets;
    mapping(address => uint256) public ticketCounts;
    mapping(uint256 => mapping(address => uint256)) public eventTicketCounts;
    
    uint256 public constant MAX_TICKETS_PER_ADDRESS = 10;
    
    event TicketMinted(uint256 indexed ticketId, uint256 indexed eventId, address indexed buyer, uint256 price);
    event PaymentReceived(address indexed buyer, uint256 amount, uint256 eventId);
    event RefundIssued(address indexed buyer, uint256 amount);
    
    constructor() ERC721("EventTicket", "ETKT") {}
    
    function mintTicket(
        uint256 _eventId,
        uint256 _seatNumber
    ) external payable nonReentrant returns (uint256) {
        Event storage eventData = events[_eventId];
        require(eventData.isActive, "Event not active");
        require(eventData.ticketsSold < eventData.maxSupply, "Sold out");
        require(msg.value >= eventData.ticketPrice, "Insufficient payment");
        require(ticketCounts[msg.sender] < MAX_TICKETS_PER_ADDRESS, "Ticket limit exceeded");
        require(eventTicketCounts[_eventId][msg.sender] < 5, "Event ticket limit exceeded");
        
        _tokenIds.increment();
        uint256 tokenId = _tokenIds.current();
        
        tickets[tokenId] = Ticket({
            ticketId: tokenId,
            eventId: _eventId,
            originalBuyer: msg.sender,
            isUsed: false,
            seatNumber: _seatNumber,
            purchasePrice: msg.value,
            purchaseTime: block.timestamp
        });
        
        eventData.ticketsSold++;
        ticketCounts[msg.sender]++;
        eventTicketCounts[_eventId][msg.sender]++;
        
        _mint(msg.sender, tokenId);
        
        emit TicketMinted(tokenId, _eventId, msg.sender, msg.value);
        emit PaymentReceived(msg.sender, msg.value, _eventId);
        
        return tokenId;
    }
}