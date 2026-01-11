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
        
        // Refund excess payment
        uint256 excess = msg.value - eventData.ticketPrice;
        if (excess > 0) {
            payable(msg.sender).transfer(excess);
            emit RefundIssued(msg.sender, excess);
        }
        
        emit TicketMinted(tokenId, _eventId, msg.sender, eventData.ticketPrice);
        emit PaymentReceived(msg.sender, eventData.ticketPrice, _eventId);
        
        return tokenId;
    }
    
    function mintTicketsBatch(
        uint256 _eventId,
        uint256[] calldata _seatNumbers
    ) external payable nonReentrant returns (uint256[] memory) {
        require(_seatNumbers.length > 0 && _seatNumbers.length <= 5, "Invalid batch size");
        
        Event storage eventData = events[_eventId];
        require(eventData.isActive, "Event not active");
        require(eventData.ticketsSold + _seatNumbers.length <= eventData.maxSupply, "Insufficient capacity");
        
        uint256 totalCost = eventData.ticketPrice * _seatNumbers.length;
        require(msg.value >= totalCost, "Insufficient payment");
        require(ticketCounts[msg.sender] + _seatNumbers.length <= MAX_TICKETS_PER_ADDRESS, "Ticket limit exceeded");
        require(eventTicketCounts[_eventId][msg.sender] + _seatNumbers.length <= 5, "Event ticket limit exceeded");
        
        uint256[] memory tokenIds = new uint256[](_seatNumbers.length);
        
        for (uint256 i = 0; i < _seatNumbers.length; i++) {
            _tokenIds.increment();
            uint256 tokenId = _tokenIds.current();
            
            tickets[tokenId] = Ticket({
                ticketId: tokenId,
                eventId: _eventId,
                originalBuyer: msg.sender,
                isUsed: false,
                seatNumber: _seatNumbers[i],
                purchasePrice: eventData.ticketPrice,
                purchaseTime: block.timestamp
            });
            
            _mint(msg.sender, tokenId);
            tokenIds[i] = tokenId;
            
            emit TicketMinted(tokenId, _eventId, msg.sender, eventData.ticketPrice);
        }
        
        eventData.ticketsSold += _seatNumbers.length;
        ticketCounts[msg.sender] += _seatNumbers.length;
        eventTicketCounts[_eventId][msg.sender] += _seatNumbers.length;
        
        // Refund excess payment
        uint256 excess = msg.value - totalCost;
        if (excess > 0) {
            payable(msg.sender).transfer(excess);
            emit RefundIssued(msg.sender, excess);
        }
        
        emit PaymentReceived(msg.sender, totalCost, _eventId);
        return tokenIds;
    }
}