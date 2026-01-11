// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface IEventTicket {
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
    
    event TicketMinted(uint256 indexed ticketId, uint256 indexed eventId, address indexed buyer, uint256 price);
    event PaymentReceived(address indexed buyer, uint256 amount, uint256 eventId);
    event RefundIssued(address indexed buyer, uint256 amount);
    
    function mintTicket(uint256 _eventId, uint256 _seatNumber) external payable returns (uint256);
    function mintTicketsBatch(uint256 _eventId, uint256[] calldata _seatNumbers) external payable returns (uint256[] memory);
    function createEvent(string calldata _name, uint256 _date, string calldata _venue, uint256 _ticketPrice, uint256 _maxSupply) external returns (uint256);
    function withdrawEventFunds(uint256 _eventId) external;
    function getTicket(uint256 _ticketId) external view returns (Ticket memory);
    function getEvent(uint256 _eventId) external view returns (Event memory);
    function getTicketCount(address _buyer) external view returns (uint256);
    function getEventTicketCount(uint256 _eventId, address _buyer) external view returns (uint256);
}