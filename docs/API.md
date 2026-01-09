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

## Usage Examples

### JavaScript/TypeScript Examples

#### Setting up Contract Instances

```javascript
import { ethers } from 'ethers';
import EventTicketABI from './abis/EventTicket.json';
import TicketMarketplaceABI from './abis/TicketMarketplace.json';

// Contract addresses (replace with actual deployed addresses)
const EVENT_TICKET_ADDRESS = '0x...';
const MARKETPLACE_ADDRESS = '0x...';

// Setup provider and signer
const provider = new ethers.providers.JsonRpcProvider('https://mainnet.base.org');
const signer = new ethers.Wallet(process.env.PRIVATE_KEY, provider);

// Contract instances
const eventTicketContract = new ethers.Contract(
    EVENT_TICKET_ADDRESS,
    EventTicketABI,
    signer
);

const marketplaceContract = new ethers.Contract(
    MARKETPLACE_ADDRESS,
    TicketMarketplaceABI,
    signer
);
```

#### Creating an Event

```javascript
async function createEvent() {
    try {
        const eventData = {
            name: "Base Music Festival 2024",
            description: "Annual music festival featuring top artists",
            date: Math.floor(Date.now() / 1000) + (30 * 24 * 60 * 60), // 30 days from now
            venue: "Base Arena, San Francisco",
            totalTickets: 1000,
            ticketPrice: ethers.utils.parseEther("0.1"), // 0.1 ETH
            maxTransferPrice: ethers.utils.parseEther("0.15"), // Max resale 0.15 ETH
            transferable: true
        };

        const tx = await eventTicketContract.createEvent(
            eventData.name,
            eventData.description,
            eventData.date,
            eventData.venue,
            eventData.totalTickets,
            eventData.ticketPrice,
            eventData.maxTransferPrice,
            eventData.transferable
        );

        const receipt = await tx.wait();
        const eventCreatedEvent = receipt.events.find(e => e.event === 'EventCreated');
        const eventId = eventCreatedEvent.args.eventId;

        console.log(`Event created with ID: ${eventId}`);
        return eventId;
    } catch (error) {
        console.error('Error creating event:', error);
        throw error;
    }
}
```

#### Minting a Ticket

```javascript
async function mintTicket(eventId, seatNumber) {
    try {
        // Get event details to check price
        const event = await eventTicketContract.events(eventId);
        const ticketPrice = event.ticketPrice;

        // Generate QR code (in practice, this would be more sophisticated)
        const qrCode = `EVENT_${eventId}_SEAT_${seatNumber}_${Date.now()}`;

        const tx = await eventTicketContract.mintTicket(
            eventId,
            seatNumber,
            qrCode,
            {
                value: ticketPrice
            }
        );

        const receipt = await tx.wait();
        const ticketMintedEvent = receipt.events.find(e => e.event === 'TicketMinted');
        const ticketId = ticketMintedEvent.args.ticketId;

        console.log(`Ticket minted with ID: ${ticketId}`);
        return ticketId;
    } catch (error) {
        console.error('Error minting ticket:', error);
        throw error;
    }
}
```

#### Verifying a Ticket

```javascript
async function verifyTicket(ticketId) {
    try {
        // Check if ticket exists and is not already used
        const ticket = await eventTicketContract.tickets(ticketId);
        
        if (ticket.isUsed) {
            throw new Error('Ticket already used');
        }

        const tx = await eventTicketContract.verifyTicket(ticketId);
        await tx.wait();

        console.log(`Ticket ${ticketId} verified successfully`);
        return true;
    } catch (error) {
        console.error('Error verifying ticket:', error);
        throw error;
    }
}
```

#### Listing a Ticket for Sale

```javascript
async function listTicketForSale(ticketId, price) {
    try {
        // First approve marketplace to transfer the ticket
        const approveTx = await eventTicketContract.approve(
            MARKETPLACE_ADDRESS,
            ticketId
        );
        await approveTx.wait();

        // List the ticket
        const listTx = await marketplaceContract.listTicket(
            ticketId,
            ethers.utils.parseEther(price.toString())
        );

        const receipt = await listTx.wait();
        const ticketListedEvent = receipt.events.find(e => e.event === 'TicketListed');
        const listingId = ticketListedEvent.args.listingId;

        console.log(`Ticket listed with listing ID: ${listingId}`);
        return listingId;
    } catch (error) {
        console.error('Error listing ticket:', error);
        throw error;
    }
}
```

#### Buying a Ticket from Marketplace

```javascript
async function buyTicketFromMarketplace(listingId) {
    try {
        // Get listing details
        const listing = await marketplaceContract.getListing(listingId);
        
        if (!listing.active) {
            throw new Error('Listing is not active');
        }

        const tx = await marketplaceContract.buyTicket(listingId, {
            value: listing.price
        });

        await tx.wait();
        console.log(`Successfully purchased ticket from listing ${listingId}`);
    } catch (error) {
        console.error('Error buying ticket:', error);
        throw error;
    }
}
```

### React Hook Examples

#### useEventTicket Hook

```javascript
import { useState, useEffect } from 'react';
import { useContract, useSigner } from 'wagmi';

export function useEventTicket() {
    const { data: signer } = useSigner();
    const [events, setEvents] = useState([]);
    const [loading, setLoading] = useState(false);

    const contract = useContract({
        address: EVENT_TICKET_ADDRESS,
        abi: EventTicketABI,
        signerOrProvider: signer
    });

    const createEvent = async (eventData) => {
        setLoading(true);
        try {
            const tx = await contract.createEvent(
                eventData.name,
                eventData.description,
                eventData.date,
                eventData.venue,
                eventData.totalTickets,
                eventData.ticketPrice,
                eventData.maxTransferPrice,
                eventData.transferable
            );
            
            const receipt = await tx.wait();
            const eventCreatedEvent = receipt.events.find(e => e.event === 'EventCreated');
            return eventCreatedEvent.args.eventId;
        } finally {
            setLoading(false);
        }
    };

    const mintTicket = async (eventId, seatNumber, qrCode, ticketPrice) => {
        setLoading(true);
        try {
            const tx = await contract.mintTicket(eventId, seatNumber, qrCode, {
                value: ticketPrice
            });
            
            const receipt = await tx.wait();
            const ticketMintedEvent = receipt.events.find(e => e.event === 'TicketMinted');
            return ticketMintedEvent.args.ticketId;
        } finally {
            setLoading(false);
        }
    };

    return {
        contract,
        events,
        loading,
        createEvent,
        mintTicket
    };
}
```

### Python Examples (using Web3.py)

#### Contract Setup

```python
from web3 import Web3
import json
import os

# Setup Web3 connection
w3 = Web3(Web3.HTTPProvider('https://mainnet.base.org'))

# Load contract ABIs
with open('abis/EventTicket.json', 'r') as f:
    event_ticket_abi = json.load(f)

with open('abis/TicketMarketplace.json', 'r') as f:
    marketplace_abi = json.load(f)

# Contract addresses
EVENT_TICKET_ADDRESS = '0x...'
MARKETPLACE_ADDRESS = '0x...'

# Setup account
private_key = os.getenv('PRIVATE_KEY')
account = w3.eth.account.from_key(private_key)

# Contract instances
event_ticket_contract = w3.eth.contract(
    address=EVENT_TICKET_ADDRESS,
    abi=event_ticket_abi
)

marketplace_contract = w3.eth.contract(
    address=MARKETPLACE_ADDRESS,
    abi=marketplace_abi
)
```

#### Creating an Event (Python)

```python
def create_event(name, description, date, venue, total_tickets, ticket_price, max_transfer_price, transferable):
    try:
        # Build transaction
        transaction = event_ticket_contract.functions.createEvent(
            name,
            description,
            date,
            venue,
            total_tickets,
            w3.toWei(ticket_price, 'ether'),
            w3.toWei(max_transfer_price, 'ether'),
            transferable
        ).buildTransaction({
            'from': account.address,
            'nonce': w3.eth.get_transaction_count(account.address),
            'gas': 500000,
            'gasPrice': w3.toWei('20', 'gwei')
        })

        # Sign and send transaction
        signed_txn = w3.eth.account.sign_transaction(transaction, private_key)
        tx_hash = w3.eth.send_raw_transaction(signed_txn.rawTransaction)
        
        # Wait for receipt
        receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
        
        # Parse event logs
        event_logs = event_ticket_contract.events.EventCreated().processReceipt(receipt)
        event_id = event_logs[0]['args']['eventId']
        
        print(f"Event created with ID: {event_id}")
        return event_id
        
    except Exception as e:
        print(f"Error creating event: {e}")
        raise
```

### Solidity Integration Examples

#### Custom Contract Integration

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./interfaces/IEventTicket.sol";
import "./interfaces/ITicketMarketplace.sol";

contract EventManager {
    IEventTicket public eventTicket;
    ITicketMarketplace public marketplace;
    
    mapping(address => uint256[]) public userEvents;
    mapping(uint256 => address) public eventOrganizers;
    
    event EventManagerCreated(uint256 indexed eventId, address organizer);
    
    constructor(address _eventTicket, address _marketplace) {
        eventTicket = IEventTicket(_eventTicket);
        marketplace = ITicketMarketplace(_marketplace);
    }
    
    function createManagedEvent(
        string memory _name,
        string memory _description,
        uint256 _date,
        string memory _venue,
        uint256 _totalTickets,
        uint256 _ticketPrice,
        uint256 _maxTransferPrice,
        bool _transferable
    ) external returns (uint256) {
        uint256 eventId = eventTicket.createEvent(
            _name,
            _description,
            _date,
            _venue,
            _totalTickets,
            _ticketPrice,
            _maxTransferPrice,
            _transferable
        );
        
        userEvents[msg.sender].push(eventId);
        eventOrganizers[eventId] = msg.sender;
        
        emit EventManagerCreated(eventId, msg.sender);
        return eventId;
    }
    
    function getUserEvents(address user) external view returns (uint256[] memory) {
        return userEvents[user];
    }
}
```

### Error Handling Examples

#### Common Error Scenarios

```javascript
// Error handling for common scenarios
async function handleTicketPurchase(eventId, seatNumber) {
    try {
        const event = await eventTicketContract.events(eventId);
        
        // Check if event is active
        if (!event.isActive) {
            throw new Error('Event is not active');
        }
        
        // Check if tickets are available
        if (event.ticketsSold >= event.totalTickets) {
            throw new Error('Event is sold out');
        }
        
        // Check if user has sufficient balance
        const balance = await signer.getBalance();
        if (balance.lt(event.ticketPrice)) {
            throw new Error('Insufficient balance');
        }
        
        const qrCode = generateQRCode(eventId, seatNumber);
        const ticketId = await mintTicket(eventId, seatNumber, qrCode);
        
        return ticketId;
        
    } catch (error) {
        if (error.code === 'INSUFFICIENT_FUNDS') {
            throw new Error('Insufficient funds for transaction');
        } else if (error.message.includes('Event not active')) {
            throw new Error('This event is no longer accepting ticket purchases');
        } else if (error.message.includes('Sold out')) {
            throw new Error('Sorry, this event is sold out');
        } else {
            throw new Error(`Transaction failed: ${error.message}`);
        }
    }
}
```

### Testing Examples

#### Unit Test Example (JavaScript/Mocha)

```javascript
const { expect } = require('chai');
const { ethers } = require('hardhat');

describe('EventTicket', function () {
    let eventTicket;
    let marketplace;
    let owner;
    let organizer;
    let buyer;

    beforeEach(async function () {
        [owner, organizer, buyer] = await ethers.getSigners();
        
        const EventTicket = await ethers.getContractFactory('EventTicket');
        eventTicket = await EventTicket.deploy();
        
        const TicketMarketplace = await ethers.getContractFactory('TicketMarketplace');
        marketplace = await TicketMarketplace.deploy(eventTicket.address, owner.address);
    });

    it('Should create an event successfully', async function () {
        const eventData = {
            name: 'Test Event',
            description: 'Test Description',
            date: Math.floor(Date.now() / 1000) + 86400,
            venue: 'Test Venue',
            totalTickets: 100,
            ticketPrice: ethers.utils.parseEther('0.1'),
            maxTransferPrice: ethers.utils.parseEther('0.15'),
            transferable: true
        };

        const tx = await eventTicket.connect(organizer).createEvent(
            eventData.name,
            eventData.description,
            eventData.date,
            eventData.venue,
            eventData.totalTickets,
            eventData.ticketPrice,
            eventData.maxTransferPrice,
            eventData.transferable
        );

        const receipt = await tx.wait();
        const eventCreatedEvent = receipt.events.find(e => e.event === 'EventCreated');
        
        expect(eventCreatedEvent.args.eventId).to.equal(1);
        expect(eventCreatedEvent.args.name).to.equal(eventData.name);
        expect(eventCreatedEvent.args.organizer).to.equal(organizer.address);
    });

    it('Should mint a ticket successfully', async function () {
        // First create an event
        await eventTicket.connect(organizer).createEvent(
            'Test Event',
            'Test Description',
            Math.floor(Date.now() / 1000) + 86400,
            'Test Venue',
            100,
            ethers.utils.parseEther('0.1'),
            ethers.utils.parseEther('0.15'),
            true
        );

        // Mint a ticket
        const tx = await eventTicket.connect(buyer).mintTicket(
            1, // eventId
            1, // seatNumber
            'QR_CODE_123',
            { value: ethers.utils.parseEther('0.1') }
        );

        const receipt = await tx.wait();
        const ticketMintedEvent = receipt.events.find(e => e.event === 'TicketMinted');
        
        expect(ticketMintedEvent.args.ticketId).to.equal(1);
        expect(ticketMintedEvent.args.eventId).to.equal(1);
        expect(ticketMintedEvent.args.buyer).to.equal(buyer.address);
    });
});
```

## Integration Guide

### Frontend Integration

#### React Application Setup

1. **Install Dependencies**

```bash
npm install ethers wagmi @rainbow-me/rainbowkit
```

2. **Configure Wagmi Provider**

```javascript
// wagmi.config.js
import { configureChains, createConfig } from 'wagmi';
import { base, baseGoerli } from 'wagmi/chains';
import { publicProvider } from 'wagmi/providers/public';
import { getDefaultWallets } from '@rainbow-me/rainbowkit';

const { chains, publicClient, webSocketPublicClient } = configureChains(
  [base, baseGoerli],
  [publicProvider()]
);

const { connectors } = getDefaultWallets({
  appName: 'NFT Event Ticketing',
  projectId: 'YOUR_PROJECT_ID',
  chains,
});

export const wagmiConfig = createConfig({
  autoConnect: true,
  connectors,
  publicClient,
  webSocketPublicClient,
});

export { chains };
```

3. **App Component Setup**

```javascript
// App.js
import { WagmiConfig } from 'wagmi';
import { RainbowKitProvider } from '@rainbow-me/rainbowkit';
import { wagmiConfig, chains } from './wagmi.config';
import EventTicketApp from './components/EventTicketApp';

function App() {
  return (
    <WagmiConfig config={wagmiConfig}>
      <RainbowKitProvider chains={chains}>
        <EventTicketApp />
      </RainbowKitProvider>
    </WagmiConfig>
  );
}

export default App;
```

#### Backend Integration

1. **Node.js Express Server**

```javascript
// server.js
const express = require('express');
const { ethers } = require('ethers');
const EventTicketABI = require('./abis/EventTicket.json');

const app = express();
app.use(express.json());

const provider = new ethers.providers.JsonRpcProvider(process.env.BASE_RPC_URL);
const contract = new ethers.Contract(
  process.env.EVENT_TICKET_ADDRESS,
  EventTicketABI,
  provider
);

// Get event details
app.get('/api/events/:eventId', async (req, res) => {
  try {
    const { eventId } = req.params;
    const event = await contract.events(eventId);
    res.json(event);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get ticket details
app.get('/api/tickets/:ticketId', async (req, res) => {
  try {
    const { ticketId } = req.params;
    const ticket = await contract.tickets(ticketId);
    res.json(ticket);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.listen(3001, () => {
  console.log('Server running on port 3001');
});
```

### Mobile Integration

#### React Native Setup

```javascript
// Mobile wallet integration
import { WalletConnect } from '@walletconnect/client';
import { ethers } from 'ethers';

class MobileTicketService {
  constructor() {
    this.connector = new WalletConnect({
      bridge: 'https://bridge.walletconnect.org',
      qrcodeModal: QRCodeModal,
    });
  }

  async connectWallet() {
    if (!this.connector.connected) {
      await this.connector.createSession();
    }
    return this.connector.accounts[0];
  }

  async purchaseTicket(eventId, seatNumber) {
    const provider = new ethers.providers.Web3Provider(this.connector);
    const signer = provider.getSigner();
    
    const contract = new ethers.Contract(
      EVENT_TICKET_ADDRESS,
      EventTicketABI,
      signer
    );

    const event = await contract.events(eventId);
    const qrCode = this.generateQRCode(eventId, seatNumber);
    
    const tx = await contract.mintTicket(eventId, seatNumber, qrCode, {
      value: event.ticketPrice
    });

    return await tx.wait();
  }

  generateQRCode(eventId, seatNumber) {
    return `EVENT_${eventId}_SEAT_${seatNumber}_${Date.now()}`;
  }
}
```

### QR Code Integration

#### QR Code Generation

```javascript
// QR Code service
import QRCode from 'qrcode';
import crypto from 'crypto';

class QRCodeService {
  static generateTicketQR(ticketId, eventId, seatNumber) {
    const timestamp = Date.now();
    const data = {
      ticketId,
      eventId,
      seatNumber,
      timestamp,
      hash: crypto
        .createHash('sha256')
        .update(`${ticketId}-${eventId}-${seatNumber}-${timestamp}`)
        .digest('hex')
    };

    return JSON.stringify(data);
  }

  static async createQRCodeImage(data) {
    try {
      const qrCodeDataURL = await QRCode.toDataURL(data, {
        errorCorrectionLevel: 'M',
        type: 'image/png',
        quality: 0.92,
        margin: 1,
        color: {
          dark: '#000000',
          light: '#FFFFFF'
        }
      });
      return qrCodeDataURL;
    } catch (error) {
      throw new Error(`QR Code generation failed: ${error.message}`);
    }
  }

  static verifyQRCode(qrData, ticketId) {
    try {
      const data = JSON.parse(qrData);
      return data.ticketId === ticketId;
    } catch (error) {
      return false;
    }
  }
}
```

#### QR Code Scanner Integration

```javascript
// QR Scanner component
import { Html5QrcodeScanner } from 'html5-qrcode';
import { useEffect, useRef } from 'react';

function QRScanner({ onScanSuccess, onScanError }) {
  const scannerRef = useRef(null);

  useEffect(() => {
    const scanner = new Html5QrcodeScanner(
      'qr-reader',
      { fps: 10, qrbox: { width: 250, height: 250 } },
      false
    );

    scanner.render(
      (decodedText) => {
        try {
          const ticketData = JSON.parse(decodedText);
          onScanSuccess(ticketData);
        } catch (error) {
          onScanError('Invalid QR code format');
        }
      },
      (error) => {
        onScanError(error);
      }
    );

    scannerRef.current = scanner;

    return () => {
      scanner.clear();
    };
  }, [onScanSuccess, onScanError]);

  return <div id="qr-reader" style={{ width: '100%' }}></div>;
}
```

### Event Listener Integration

#### Real-time Event Monitoring

```javascript
// Event monitoring service
class EventMonitorService {
  constructor(contractAddress, abi, provider) {
    this.contract = new ethers.Contract(contractAddress, abi, provider);
    this.listeners = new Map();
  }

  // Listen for new events
  onEventCreated(callback) {
    const filter = this.contract.filters.EventCreated();
    this.contract.on(filter, (eventId, name, organizer, event) => {
      callback({
        eventId: eventId.toString(),
        name,
        organizer,
        transactionHash: event.transactionHash,
        blockNumber: event.blockNumber
      });
    });
  }

  // Listen for ticket purchases
  onTicketMinted(callback) {
    const filter = this.contract.filters.TicketMinted();
    this.contract.on(filter, (ticketId, eventId, buyer, event) => {
      callback({
        ticketId: ticketId.toString(),
        eventId: eventId.toString(),
        buyer,
        transactionHash: event.transactionHash,
        blockNumber: event.blockNumber
      });
    });
  }

  // Listen for ticket verifications
  onTicketVerified(callback) {
    const filter = this.contract.filters.TicketVerified();
    this.contract.on(filter, (ticketId, verifier, event) => {
      callback({
        ticketId: ticketId.toString(),
        verifier,
        transactionHash: event.transactionHash,
        blockNumber: event.blockNumber,
        timestamp: Date.now()
      });
    });
  }

  // Remove all listeners
  removeAllListeners() {
    this.contract.removeAllListeners();
  }
}

// Usage example
const monitor = new EventMonitorService(
  EVENT_TICKET_ADDRESS,
  EventTicketABI,
  provider
);

monitor.onTicketMinted((data) => {
  console.log('New ticket minted:', data);
  // Update UI, send notifications, etc.
});
```

### IPFS Integration

#### Metadata Storage

```javascript
// IPFS service for storing ticket metadata
import { create } from 'ipfs-http-client';

class IPFSService {
  constructor() {
    this.client = create({
      host: 'ipfs.infura.io',
      port: 5001,
      protocol: 'https',
      headers: {
        authorization: `Basic ${Buffer.from(
          `${process.env.INFURA_PROJECT_ID}:${process.env.INFURA_PROJECT_SECRET}`
        ).toString('base64')}`
      }
    });
  }

  async uploadTicketMetadata(ticketData) {
    const metadata = {
      name: `${ticketData.eventName} - Seat ${ticketData.seatNumber}`,
      description: `Ticket for ${ticketData.eventName} at ${ticketData.venue}`,
      image: ticketData.imageUrl,
      attributes: [
        {
          trait_type: 'Event',
          value: ticketData.eventName
        },
        {
          trait_type: 'Venue',
          value: ticketData.venue
        },
        {
          trait_type: 'Date',
          value: new Date(ticketData.date * 1000).toISOString()
        },
        {
          trait_type: 'Seat Number',
          value: ticketData.seatNumber.toString()
        }
      ]
    };

    const result = await this.client.add(JSON.stringify(metadata));
    return `https://ipfs.io/ipfs/${result.path}`;
  }

  async getMetadata(ipfsHash) {
    const stream = this.client.cat(ipfsHash);
    let data = '';
    
    for await (const chunk of stream) {
      data += chunk.toString();
    }
    
    return JSON.parse(data);
  }
}
```

### Security Best Practices

#### Input Validation

```javascript
// Validation utilities
class ValidationUtils {
  static validateEventData(eventData) {
    const errors = [];

    if (!eventData.name || eventData.name.trim().length === 0) {
      errors.push('Event name is required');
    }

    if (!eventData.date || eventData.date <= Date.now() / 1000) {
      errors.push('Event date must be in the future');
    }

    if (!eventData.totalTickets || eventData.totalTickets <= 0) {
      errors.push('Total tickets must be greater than 0');
    }

    if (!eventData.ticketPrice || eventData.ticketPrice <= 0) {
      errors.push('Ticket price must be greater than 0');
    }

    return errors;
  }

  static validateAddress(address) {
    return ethers.utils.isAddress(address);
  }

  static sanitizeString(input) {
    return input.replace(/[<>]/g, '');
  }
}
```

#### Rate Limiting

```javascript
// Rate limiting middleware
const rateLimit = require('express-rate-limit');

const ticketPurchaseLimit = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 5, // Limit each IP to 5 ticket purchases per windowMs
  message: 'Too many ticket purchase attempts, please try again later',
  standardHeaders: true,
  legacyHeaders: false,
});

app.use('/api/purchase', ticketPurchaseLimit);
```

### Deployment Guide

#### Hardhat Deployment Script

```javascript
// scripts/deploy.js
const { ethers } = require('hardhat');

async function main() {
  console.log('Deploying contracts to Base network...');

  // Deploy EventTicket contract
  const EventTicket = await ethers.getContractFactory('EventTicket');
  const eventTicket = await EventTicket.deploy();
  await eventTicket.deployed();
  console.log('EventTicket deployed to:', eventTicket.address);

  // Deploy TicketMarketplace contract
  const TicketMarketplace = await ethers.getContractFactory('TicketMarketplace');
  const marketplace = await TicketMarketplace.deploy(
    eventTicket.address,
    process.env.FEE_RECIPIENT_ADDRESS
  );
  await marketplace.deployed();
  console.log('TicketMarketplace deployed to:', marketplace.address);

  // Verify contracts on Basescan
  if (network.name !== 'hardhat') {
    console.log('Waiting for block confirmations...');
    await eventTicket.deployTransaction.wait(6);
    await marketplace.deployTransaction.wait(6);

    await hre.run('verify:verify', {
      address: eventTicket.address,
      constructorArguments: [],
    });

    await hre.run('verify:verify', {
      address: marketplace.address,
      constructorArguments: [eventTicket.address, process.env.FEE_RECIPIENT_ADDRESS],
    });
  }

  // Save deployment info
  const deploymentInfo = {
    network: network.name,
    eventTicket: eventTicket.address,
    marketplace: marketplace.address,
    deployer: (await ethers.getSigners())[0].address,
    timestamp: new Date().toISOString()
  };

  console.log('Deployment completed:', deploymentInfo);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
```

#### Environment Configuration

```bash
# .env file
PRIVATE_KEY=your_private_key_here
BASE_RPC_URL=https://mainnet.base.org
BASE_SEPOLIA_RPC_URL=https://sepolia.base.org
BASESCAN_API_KEY=your_basescan_api_key
FEE_RECIPIENT_ADDRESS=0x...
INFURA_PROJECT_ID=your_infura_project_id
INFURA_PROJECT_SECRET=your_infura_project_secret
```

### Troubleshooting

#### Common Issues and Solutions

1. **Transaction Reverted: "Event not active"**
   - Check if the event exists and is still active
   - Verify the event date hasn't passed

2. **Transaction Reverted: "Insufficient payment"**
   - Ensure the sent value matches or exceeds the ticket price
   - Account for gas fees in the transaction

3. **Transaction Reverted: "Sold out"**
   - Check if tickets are still available
   - Implement proper UI feedback for sold-out events

4. **QR Code Verification Failed**
   - Ensure QR code format matches expected structure
   - Verify ticket hasn't been used already

5. **Marketplace Approval Issues**
   - Ensure proper token approval before listing
   - Check if the marketplace contract address is correct

#### Debug Utilities

```javascript
// Debug helper functions
class DebugUtils {
  static async getTransactionDetails(txHash, provider) {
    const tx = await provider.getTransaction(txHash);
    const receipt = await provider.getTransactionReceipt(txHash);
    
    return {
      transaction: tx,
      receipt: receipt,
      gasUsed: receipt.gasUsed.toString(),
      effectiveGasPrice: receipt.effectiveGasPrice?.toString(),
      status: receipt.status === 1 ? 'Success' : 'Failed'
    };
  }

  static async estimateGas(contract, method, params) {
    try {
      const gasEstimate = await contract.estimateGas[method](...params);
      return gasEstimate.toString();
    } catch (error) {
      console.error('Gas estimation failed:', error);
      return null;
    }
  }

  static formatError(error) {
    if (error.reason) {
      return error.reason;
    } else if (error.message) {
      return error.message;
    } else {
      return 'Unknown error occurred';
    }
  }
}
```

This comprehensive integration guide provides developers with all the necessary information to integrate the NFT Event Ticketing System into their applications, covering frontend, backend, mobile, and security considerations.