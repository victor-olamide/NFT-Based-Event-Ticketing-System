// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title IEventTicket
 * @dev Interface for EventTicket contract
 */
interface IEventTicket {
    
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
    
    event EventCreated(
        uint256 indexed eventId, 
        string name, 
        address indexed organizer,
        uint256 maxSupply,
        TransferRestriction transferRestriction
    );
    event TicketMinted(uint256 indexed ticketId, uint256 indexed eventId, address buyer);
    event TicketVerified(uint256 indexed ticketId, address verifier);
    
    function createEvent(
        string calldata _name,
        uint256 _date,
        string calldata _venue,
        uint256 _ticketPrice,
        uint256 _maxSupply,
        TransferRestriction _transferRestriction
    ) external returns (uint256);
    
    function mintTicket(
        uint256 _eventId,
        uint256 _seatNumber
    ) external payable returns (uint256);
    
    function verifyTicket(uint256 _ticketId) external returns (bool);
    
    function getEvent(uint256 _eventId) external view returns (Event memory);
    
    function getTicket(uint256 _ticketId) external view returns (Ticket memory);
    
    function totalSupply() external view returns (uint256);
    
    function totalEvents() external view returns (uint256);
}