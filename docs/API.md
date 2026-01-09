# Smart Contract API Documentation

## Overview

This documentation provides comprehensive information about the NFT Event Ticketing System smart contracts deployed on Base network. The system consists of two main contracts:

1. **EventTicket.sol** - Core NFT ticketing functionality
2. **TicketMarketplace.sol** - Secondary market trading with royalties

## Table of Contents

- [EventTicket Contract](#eventticket-contract)
- [TicketMarketplace Contract](#ticketmarketplace-contract)
- [Data Structures](#data-structures)
- [Events](#events)
- [Usage Examples](#usage-examples)
- [Integration Guide](#integration-guide)

## Contract Addresses

### Base Mainnet
- EventTicket: `TBD`
- TicketMarketplace: `TBD`

### Base Sepolia Testnet
- EventTicket: `TBD`
- TicketMarketplace: `TBD`

## EventTicket Contract

The EventTicket contract is the core NFT contract that handles event creation, ticket minting, and verification.

### Constructor

```solidity
constructor() ERC721("EventTicket", "ETKT")
```

Initializes the contract with name "EventTicket" and symbol "ETKT".

### State Variables

| Variable | Type | Description |
|----------|------|-------------|
| `_tokenIdCounter` | `Counters.Counter` | Counter for unique ticket IDs |
| `_eventIdCounter` | `Counters.Counter` | Counter for unique event IDs |
| `events` | `mapping(uint256 => Event)` | Mapping of event ID to Event struct |
| `tickets` | `mapping(uint256 => Ticket)` | Mapping of ticket ID to Ticket struct |
| `verifiedTickets` | `mapping(uint256 => bool)` | Mapping of verified ticket IDs |

### Functions

#### createEvent

```solidity
function createEvent(
    string memory _name,
    string memory _description,
    uint256 _date,
    string memory _venue,
    uint256 _totalTickets,
    uint256 _ticketPrice,
    uint256 _maxTransferPrice,
    bool _transferable
) external returns (uint256)
```

Creates a new event and returns the event ID.

**Parameters:**
- `_name`: Event name
- `_description`: Event description
- `_date`: Event date (Unix timestamp)
- `_venue`: Event venue location
- `_totalTickets`: Maximum number of tickets available
- `_ticketPrice`: Price per ticket in wei
- `_maxTransferPrice`: Maximum resale price (anti-scalping)
- `_transferable`: Whether tickets can be transferred

**Returns:** `uint256` - The created event ID

**Events Emitted:** `EventCreated(eventId, name, organizer)`

#### mintTicket

```solidity
function mintTicket(
    uint256 _eventId,
    uint256 _seatNumber,
    string memory _qrCode
) external payable nonReentrant returns (uint256)
```

Mints a new ticket NFT for the specified event.

**Parameters:**
- `_eventId`: ID of the event
- `_seatNumber`: Seat number for the ticket
- `_qrCode`: QR code string for verification

**Requirements:**
- Event must be active
- Tickets must be available
- Payment must be sufficient

**Returns:** `uint256` - The minted ticket ID

**Events Emitted:** `TicketMinted(ticketId, eventId, buyer)`

#### verifyTicket

```solidity
function verifyTicket(uint256 _ticketId) external returns (bool)
```

Verifies a ticket at the venue entrance.

**Parameters:**
- `_ticketId`: ID of the ticket to verify

**Requirements:**
- Ticket must exist
- Ticket must not be already used

**Returns:** `bool` - True if verification successful

**Events Emitted:** `TicketVerified(ticketId, verifier)`

### View Functions

#### events

```solidity
function events(uint256 _eventId) external view returns (Event memory)
```

Returns event details for the given event ID.

#### tickets

```solidity
function tickets(uint256 _ticketId) external view returns (Ticket memory)
```

Returns ticket details for the given ticket ID.

#### verifiedTickets

```solidity
function verifiedTickets(uint256 _ticketId) external view returns (bool)
```

Returns whether a ticket has been verified.

## TicketMarketplace Contract

The TicketMarketplace contract handles secondary market trading of tickets with royalty support.

### Constructor

```solidity
constructor(address _ticketContract, address _feeRecipient)
```

**Parameters:**
- `_ticketContract`: Address of the EventTicket contract
- `_feeRecipient`: Address to receive platform fees

### State Variables

| Variable | Type | Description |
|----------|------|-------------|
| `listings` | `mapping(uint256 => Listing)` | Mapping of listing ID to Listing struct |
| `royalties` | `mapping(address => RoyaltyInfo)` | Royalty info per collection |
| `listingIds` | `mapping(uint256 => uint256)` | Token ID to listing ID mapping |
| `platformFee` | `uint256` | Platform fee in basis points (default: 250 = 2.5%) |
| `feeRecipient` | `address` | Address receiving platform fees |
| `ticketContract` | `IERC721` | Reference to ticket contract |

### Functions

#### listTicket

```solidity
function listTicket(uint256 _tokenId, uint256 _price) external nonReentrant returns (uint256)
```

Lists a ticket for sale on the marketplace.

**Parameters:**
- `_tokenId`: ID of the ticket to list
- `_price`: Sale price in wei

**Requirements:**
- Caller must own the token
- Contract must be approved to transfer token
- Price must be greater than 0

**Returns:** `uint256` - The listing ID

**Events Emitted:** `TicketListed(listingId, tokenId, seller, price)`

#### buyTicket

```solidity
function buyTicket(uint256 _listingId) external payable nonReentrant
```

Purchases a listed ticket.

**Parameters:**
- `_listingId`: ID of the listing to purchase

**Requirements:**
- Listing must be active
- Payment must be sufficient
- Buyer cannot be the seller

**Events Emitted:** `TicketSold(listingId, tokenId, buyer, price)`

#### cancelListing

```solidity
function cancelListing(uint256 _listingId) external
```

Cancels an active listing.

**Parameters:**
- `_listingId`: ID of the listing to cancel

**Requirements:**
- Caller must be seller or contract owner

**Events Emitted:** `ListingCancelled(listingId, tokenId)`

#### setRoyaltyInfo

```solidity
function setRoyaltyInfo(
    address _collection,
    address _recipient,
    uint96 _royaltyFraction
) external onlyOwner
```

Sets royalty information for a collection.

**Parameters:**
- `_collection`: Collection contract address
- `_recipient`: Address to receive royalties
- `_royaltyFraction`: Royalty percentage in basis points (max 1000 = 10%)

**Events Emitted:** `RoyaltySet(collection, recipient, royaltyFraction)`

### View Functions

#### getListing

```solidity
function getListing(uint256 _listingId) external view returns (Listing memory)
```

Returns listing details for the given listing ID.

#### isTokenListed

```solidity
function isTokenListed(uint256 _tokenId) external view returns (bool)
```

Returns whether a token is currently listed for sale.

## Data Structures

### Event Struct

```solidity
struct Event {
    uint256 eventId;        // Unique event identifier
    string name;            // Event name
    string description;     // Event description
    uint256 date;          // Event date (Unix timestamp)
    string venue;          // Event venue
    uint256 totalTickets;  // Total tickets available
    uint256 ticketsSold;   // Number of tickets sold
    uint256 ticketPrice;   // Price per ticket in wei
    address organizer;     // Event organizer address
    bool isActive;         // Whether event is active
    uint256 maxTransferPrice; // Maximum resale price
    bool transferable;     // Whether tickets can be transferred
}
```

### Ticket Struct

```solidity
struct Ticket {
    uint256 ticketId;      // Unique ticket identifier
    uint256 eventId;       // Associated event ID
    address originalBuyer; // Original purchaser address
    bool isUsed;          // Whether ticket has been used
    uint256 seatNumber;   // Seat number
    string qrCode;        // QR code for verification
}
```

### Listing Struct

```solidity
struct Listing {
    uint256 tokenId;      // Token ID being sold
    address seller;       // Seller address
    uint256 price;        // Sale price in wei
    bool active;          // Whether listing is active
    uint256 listedAt;     // Timestamp when listed
}
```

### RoyaltyInfo Struct

```solidity
struct RoyaltyInfo {
    address recipient;        // Royalty recipient address
    uint96 royaltyFraction;  // Royalty percentage in basis points
}
```

## Events

### EventTicket Contract Events

#### EventCreated
```solidity
event EventCreated(uint256 indexed eventId, string name, address organizer);
```
Emitted when a new event is created.

#### TicketMinted
```solidity
event TicketMinted(uint256 indexed ticketId, uint256 indexed eventId, address buyer);
```
Emitted when a ticket is minted.

#### TicketVerified
```solidity
event TicketVerified(uint256 indexed ticketId, address verifier);
```
Emitted when a ticket is verified at venue.

#### TicketTransferred
```solidity
event TicketTransferred(uint256 indexed ticketId, address from, address to);
```
Emitted when a ticket is transferred.

### TicketMarketplace Contract Events

#### TicketListed
```solidity
event TicketListed(uint256 indexed listingId, uint256 indexed tokenId, address seller, uint256 price);
```
Emitted when a ticket is listed for sale.

#### TicketSold
```solidity
event TicketSold(uint256 indexed listingId, uint256 indexed tokenId, address buyer, uint256 price);
```
Emitted when a ticket is sold.

#### ListingCancelled
```solidity
event ListingCancelled(uint256 indexed listingId, uint256 indexed tokenId);
```
Emitted when a listing is cancelled.

#### RoyaltySet
```solidity
event RoyaltySet(address indexed collection, address recipient, uint96 royaltyFraction);
```
Emitted when royalty information is set.