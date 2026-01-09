# NFT Event Ticketing System

A decentralized event ticketing platform using NFTs to prevent fraud and enable transparent secondary market trading.

## Features

- **NFT Tickets**: Each ticket is a unique NFT with event metadata
- **QR Verification**: Secure venue entry with QR code scanning
- **Royalty System**: Event organizers earn from secondary sales
- **Transfer Controls**: Prevent scalping with price caps and transfer restrictions
- **Event Management**: Create and manage events with custom parameters

## Tech Stack

- **Smart Contracts**: Solidity, OpenZeppelin
- **Frontend**: Next.js, React, TypeScript
- **Blockchain**: Ethereum/Polygon
- **Web3**: Ethers.js
- **Storage**: IPFS for metadata
- **Styling**: Tailwind CSS

## Quick Start

```bash
# Clone repository
git clone <repository-url>
cd nft-ticketing-system

# Install dependencies
npm install

# Start local blockchain
npx hardhat node

# Deploy contracts
npx hardhat run scripts/deploy.js --network localhost

# Start frontend
npm run dev
```

## Smart Contract Functions

### Event Creation
- `createEvent()` - Create new event with ticket parameters
- `setEventDetails()` - Update event information

### Ticket Management
- `mintTicket()` - Purchase tickets (mint NFTs)
- `transferTicket()` - Transfer ticket to another address
- `verifyTicket()` - Verify ticket authenticity at venue

### Secondary Market
- `listForSale()` - List ticket on marketplace
- `buyFromMarketplace()` - Purchase from secondary market
- `setRoyaltyInfo()` - Configure royalty percentages

## Project Structure

```
├── contracts/
│   ├── EventTicket.sol
│   ├── TicketMarketplace.sol
│   └── interfaces/
├── frontend/
│   ├── components/
│   ├── pages/
│   └── utils/
├── scripts/
│   └── deploy.js
└── test/
    └── EventTicket.test.js
```

## Environment Variables

```env
PRIVATE_KEY=your_private_key
INFURA_PROJECT_ID=your_infura_id
ETHERSCAN_API_KEY=your_etherscan_key
```

## License

MIT License