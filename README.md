# NFT Event Ticketing System - Base Network

A decentralized event ticketing platform built on **Base** using NFTs to prevent fraud and enable transparent secondary market trading. This project leverages Base's low-cost, fast transactions to make event ticketing accessible and affordable.

## 🎫 Features

- **NFT Tickets**: Each ticket is a unique NFT with event metadata
- **QR Verification**: Secure venue entry with QR code scanning
- **Royalty System**: Event organizers earn from secondary sales
- **Transfer Controls**: Prevent scalping with price caps and transfer restrictions
- **Event Management**: Create and manage events with custom parameters
- **Secondary Marketplace**: Built-in marketplace for ticket resales
- **Anti-Fraud Protection**: Blockchain-based verification prevents counterfeiting

## 🛠️ Tech Stack

- **Smart Contracts**: Solidity ^0.8.19, OpenZeppelin
- **Frontend**: Next.js 13, React 18, TypeScript
- **Blockchain**: Base (Ethereum L2)
- **Web3**: Ethers.js v6, Wagmi, RainbowKit
- **Storage**: IPFS for metadata
- **Styling**: Tailwind CSS
- **Testing**: Hardhat, Chai, Mocha

## 📚 Documentation

### For Users
- **[Getting Started Guide](./docs/user-guides/getting-started.md)** - Complete beginner's guide to NFT ticketing
- **[Quick Start Tutorial](./docs/tutorials/quick-start.md)** - Get up and running in 15 minutes
- **[User Onboarding](./docs/user-guides/onboarding.md)** - Role-specific onboarding paths
- **[FAQ](./docs/user-guides/faq.md)** - Frequently asked questions and answers
- **[Troubleshooting](./docs/user-guides/troubleshooting.md)** - Technical issue resolution

### For Specific Roles
- **[Event Organizer Tutorial](./docs/tutorials/event-organizer-tutorial.md)** - Complete event creation guide
- **[Ticket Buyer Tutorial](./docs/tutorials/ticket-buyer-tutorial.md)** - Purchasing and managing tickets
- **[Marketplace Tutorial](./docs/tutorials/marketplace-tutorial.md)** - Secondary market trading
- **[Venue Staff Tutorial](./docs/tutorials/venue-staff-tutorial.md)** - Ticket verification guide

### For Developers
- **[Complete API Documentation](./docs/API.md)** - Comprehensive smart contract API reference
- **[API Quick Reference](./docs/API-Reference.md)** - Error codes, gas estimates, and optimization tips
- **[Frontend Integration Guide](./docs/Frontend-Integration.md)** - React components and Web3 setup
- **[Documentation Index](./docs/README.md)** - Complete documentation overview

## 🚀 Quick Start

### New to NFT Tickets?
1. **[Read Getting Started Guide](./docs/user-guides/getting-started.md)** - Understand the basics
2. **[Follow Quick Start Tutorial](./docs/tutorials/quick-start.md)** - Get up and running in 15 minutes
3. **[Set Up Your Wallet](./docs/user-guides/wallet-setup.md)** - Secure wallet configuration

### For Developers

```bash
# Clone repository
git clone https://github.com/victor-olamide/NFT-Based-Event-Ticketing-System.git
cd NFT-Based-Event-Ticketing-System

# Install dependencies
npm install

# Start local blockchain
npx hardhat node

# Deploy contracts to Base testnet
npx hardhat run scripts/deploy.js --network base-sepolia

# Deploy to Base mainnet
npx hardhat run scripts/deploy.js --network base

# Start frontend
npm run dev
```

## 📋 Smart Contract API

### EventTicket Contract

| Function | Description | Gas Estimate |
|----------|-------------|-------------|
| `createEvent()` | Create new event with ticket parameters | ~150,000 |
| `mintTicket()` | Purchase tickets (mint NFTs) | ~120,000 |
| `verifyTicket()` | Verify ticket authenticity at venue | ~45,000 |
| `transferFrom()` | Transfer ticket to another address | ~85,000 |

### TicketMarketplace Contract

| Function | Description | Gas Estimate |
|----------|-------------|-------------|
| `listTicket()` | List ticket for sale on marketplace | ~75,000 |
| `buyTicket()` | Purchase from secondary market | ~150,000 |
| `cancelListing()` | Cancel marketplace listing | ~35,000 |
| `setRoyaltyInfo()` | Configure royalty percentages | ~50,000 |

### Key Features
- ✅ **Anti-scalping**: Maximum resale price controls
- ✅ **Royalty system**: Organizers earn from secondary sales
- ✅ **Transfer controls**: Optional ticket transfer restrictions
- ✅ **QR verification**: Secure venue entry system
- ✅ **Event management**: Comprehensive event lifecycle management

## 📁 Project Structure

```
├── contracts/                 # Smart contracts
│   ├── EventTicket.sol       # Main NFT ticketing contract
│   ├── TicketMarketplace.sol  # Secondary marketplace contract
│   └── interfaces/            # Contract interfaces
├── docs/                      # Comprehensive documentation
│   ├── user-guides/          # User guides and tutorials
│   │   ├── getting-started.md # Complete beginner's guide
│   │   ├── wallet-setup.md   # Wallet configuration guide
│   │   ├── onboarding.md     # Role-specific onboarding
│   │   ├── best-practices.md # Optimization strategies
│   │   ├── faq.md           # Frequently asked questions
│   │   └── troubleshooting.md # Technical issue resolution
│   ├── tutorials/            # Step-by-step tutorials
│   │   ├── quick-start.md    # 15-minute setup guide
│   │   ├── event-organizer-tutorial.md # Event creation
│   │   ├── ticket-buyer-tutorial.md # Ticket purchasing
│   │   ├── marketplace-tutorial.md # Secondary trading
│   │   ├── venue-staff-tutorial.md # Ticket verification
│   │   └── video-scripts.md  # Video tutorial scripts
│   ├── API.md                # Complete API reference
│   ├── API-Reference.md      # Quick reference guide
│   ├── Frontend-Integration.md # Frontend integration guide
│   └── README.md             # Documentation index
├── abis/                      # Contract ABIs for frontend
├── scripts/                   # Deployment scripts
│   └── deploy.js             # Main deployment script
├── test/                      # Test suites
│   ├── EventTicket.test.js   # EventTicket contract tests
│   └── TicketMarketplace.test.js # Marketplace contract tests
├── hardhat.config.js         # Hardhat configuration
├── package.json              # Dependencies and scripts
└── .env.example              # Environment variables template
```

## ⚙️ Environment Variables

```env
# Deployment Configuration
PRIVATE_KEY=your_private_key_here
BASE_RPC_URL=https://mainnet.base.org
BASE_SEPOLIA_RPC_URL=https://sepolia.base.org
BASESCAN_API_KEY=your_basescan_api_key
FEE_RECIPIENT_ADDRESS=0x...

# Frontend Configuration
NEXT_PUBLIC_EVENT_TICKET_ADDRESS=0x...
NEXT_PUBLIC_MARKETPLACE_ADDRESS=0x...
NEXT_PUBLIC_CHAIN_ID=8453
NEXT_PUBLIC_WALLET_CONNECT_PROJECT_ID=your_project_id

# Optional: IPFS Configuration
INFURA_PROJECT_ID=your_infura_project_id
INFURA_PROJECT_SECRET=your_infura_project_secret
```

## 🧪 Testing

```bash
# Run all tests
npm test

# Run specific test file
npx hardhat test test/EventTicket.test.js

# Generate coverage report
npx hardhat coverage

# Run tests with gas reporting
REPORT_GAS=true npm test
```

## 🚀 Deployment

### Base Sepolia (Testnet)
```bash
npm run deploy:base-sepolia
npm run verify:base-sepolia
```

### Base Mainnet
```bash
npm run deploy:base
npm run verify:base
```

## 📊 Contract Addresses

### Base Mainnet
- **EventTicket**: `TBD`
- **TicketMarketplace**: `TBD`

### Base Sepolia Testnet
- **EventTicket**: `TBD`
- **TicketMarketplace**: `TBD`

*Addresses will be updated after deployment*

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🔗 Links

- **Documentation**: [Complete Docs with User Guides](./docs/)
- **Getting Started**: [Beginner's Guide](./docs/user-guides/getting-started.md)
- **Quick Tutorial**: [15-Minute Setup](./docs/tutorials/quick-start.md)
- **Base Network**: [https://base.org](https://base.org)
- **OpenZeppelin**: [https://openzeppelin.com](https://openzeppelin.com)
- **Hardhat**: [https://hardhat.org](https://hardhat.org)