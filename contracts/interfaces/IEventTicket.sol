// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title IEventTicket
 * @dev Interface for EventTicket contract
 */
interface IEventTicket {
    
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
    
    event EventCreated(uint256 indexed eventId, string name, address organizer);
    event TicketMinted(uint256 indexed ticketId, uint256 indexed eventId, address buyer);
    event TicketVerified(uint256 indexed ticketId, address verifier);
    event TicketTransferred(uint256 indexed ticketId, address from, address to);
    
    function createEvent(
        string memory _name,
        string memory _description,
        uint256 _date,
        string memory _venue,
        uint256 _totalTickets,
        uint256 _ticketPrice,
        uint256 _maxTransferPrice,
        bool _transferable
    ) external returns (uint256);
    
    function mintTicket(
        uint256 _eventId,
        uint256 _seatNumber,
        string memory _qrCode
    ) external payable returns (uint256);
    
    function verifyTicket(uint256 _ticketId) external returns (bool);
    
    function events(uint256 _eventId) external view returns (Event memory);
    
    function tickets(uint256 _ticketId) external view returns (Ticket memory);
    
    function verifiedTickets(uint256 _ticketId) external view returns (bool);
}