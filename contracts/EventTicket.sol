// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract EventTicket is ERC721, Ownable, ReentrancyGuard, Pausable {
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
    ) external payable nonReentrant whenNotPaused returns (uint256) {
        Event storage eventData = events[_eventId];
        require(eventData.isActive, "Event not active");
        require(eventData.ticketsSold < eventData.maxSupply, "Sold out");
        
        if (eventData.ticketPrice > 0) {
            require(msg.value >= eventData.ticketPrice, "Insufficient payment");
        } else {
            require(msg.value == 0, "No payment required for free event");
        }
        
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
    ) external payable nonReentrant whenNotPaused returns (uint256[] memory) {
        require(_seatNumbers.length > 0 && _seatNumbers.length <= 5, "Invalid batch size");
        
        Event storage eventData = events[_eventId];
        require(eventData.isActive, "Event not active");
        require(eventData.ticketsSold + _seatNumbers.length <= eventData.maxSupply, "Insufficient capacity");
        
        uint256 totalCost = eventData.ticketPrice * _seatNumbers.length;
        if (eventData.ticketPrice > 0) {
            require(msg.value >= totalCost, "Insufficient payment");
        } else {
            require(msg.value == 0, "No payment required for free event");
        }
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
    
    function withdrawEventFunds(uint256 _eventId) external nonReentrant {
        Event storage eventData = events[_eventId];
        require(eventData.organizer == msg.sender, "Not organizer");
        
        uint256 amount = eventData.ticketsSold * eventData.ticketPrice;
        require(amount > 0, "No funds to withdraw");
        
        eventData.ticketsSold = 0; // Reset to prevent re-withdrawal
        payable(msg.sender).transfer(amount);
    }
    
    function createEvent(
        string calldata _name,
        uint256 _date,
        string calldata _venue,
        uint256 _ticketPrice,
        uint256 _maxSupply
    ) external returns (uint256) {
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
            isActive: true
        });
        
        return eventId;
    }
    
    function getTicket(uint256 _ticketId) external view returns (Ticket memory) {
        return tickets[_ticketId];
    }
    
    function getEvent(uint256 _eventId) external view returns (Event memory) {
        return events[_eventId];
    }
    
    function getTicketCount(address _buyer) external view returns (uint256) {
        return ticketCounts[_buyer];
    }
    
    function getEventTicketCount(uint256 _eventId, address _buyer) external view returns (uint256) {
        return eventTicketCounts[_eventId][_buyer];
    }
    
    function totalSupply() external view returns (uint256) {
        return _tokenIds.current();
    }
    
    function pause() external onlyOwner {
        _pause();
    }
    
    function unpause() external onlyOwner {
        _unpause();
    }
    }
}