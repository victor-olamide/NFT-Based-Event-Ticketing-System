# Documentation Index

Welcome to the NFT Event Ticketing System documentation. This comprehensive guide covers all aspects of the system, from smart contract APIs to frontend integration.

## 📚 Documentation Structure

### Core Documentation
- **[API Documentation](./API.md)** - Complete smart contract API reference with usage examples
- **[API Reference](./API-Reference.md)** - Quick reference, error codes, and optimization tips
- **[Frontend Integration](./Frontend-Integration.md)** - React/Next.js integration guide

### Quick Links

#### For Developers
- [Smart Contract Functions](./API.md#eventticket-contract)
- [Usage Examples](./API.md#usage-examples)
- [Integration Guide](./API.md#integration-guide)
- [Frontend Components](./Frontend-Integration.md#component-examples)

#### For Event Organizers
- [Creating Events](./API.md#createevent)
- [Managing Tickets](./API.md#mintticket)
- [Setting Up Royalties](./API.md#setroyaltyinfo)

#### For Ticket Buyers
- [Purchasing Tickets](./API.md#mintticket)
- [Transferring Tickets](./API.md#ticket-transfers)
- [Marketplace Trading](./API.md#ticketmarketplace-contract)

#### For Venue Operators
- [Ticket Verification](./API.md#verifyticket)
- [QR Code Integration](./API.md#qr-code-integration)

## 🚀 Getting Started

### 1. Smart Contract Deployment
```bash
# Install dependencies
npm install

# Deploy to Base Sepolia (testnet)
npx hardhat run scripts/deploy.js --network base-sepolia

# Deploy to Base mainnet
npx hardhat run scripts/deploy.js --network base
```

### 2. Frontend Setup
```bash
# Install frontend dependencies
npm install @rainbow-me/rainbowkit wagmi viem ethers

# Configure environment variables
cp .env.example .env.local
```

### 3. Basic Usage
```javascript
// Create an event
const eventId = await eventTicketContract.createEvent(
  "Base Music Festival 2024",
  "Annual music festival",
  eventDate,
  "Base Arena",
  1000,
  ethers.parseEther("0.1"),
  ethers.parseEther("0.15"),
  true
);

// Purchase a ticket
const ticketId = await eventTicketContract.mintTicket(
  eventId,
  seatNumber,
  qrCode,
  { value: ethers.parseEther("0.1") }
);
```

## 📖 Documentation Sections

### Smart Contract API
Comprehensive documentation of all smart contract functions, events, and data structures.

**Key Topics:**
- Contract deployment and configuration
- Event creation and management
- Ticket minting and verification
- Marketplace operations
- Royalty management

### Integration Examples
Real-world examples for different programming languages and frameworks.

**Covered Languages:**
- JavaScript/TypeScript (Node.js, React, Next.js)
- Python (Web3.py)
- Solidity (Contract integration)

### Frontend Integration
Complete guide for building user interfaces with React and Web3 libraries.

**Key Components:**
- Wallet connection
- Event creation forms
- Ticket purchase flows
- QR code generation and scanning
- Marketplace interfaces

### Security & Best Practices
Guidelines for secure implementation and deployment.

**Topics Covered:**
- Input validation
- Error handling
- Rate limiting
- Gas optimization
- Security auditing

## 🔧 Configuration

### Environment Variables
```bash
# Blockchain Configuration
PRIVATE_KEY=your_private_key
BASE_RPC_URL=https://mainnet.base.org
BASESCAN_API_KEY=your_api_key

# Contract Addresses
NEXT_PUBLIC_EVENT_TICKET_ADDRESS=0x...
NEXT_PUBLIC_MARKETPLACE_ADDRESS=0x...

# Frontend Configuration
NEXT_PUBLIC_CHAIN_ID=8453
NEXT_PUBLIC_WALLET_CONNECT_PROJECT_ID=your_project_id
```

### Network Configuration
```javascript
// Hardhat configuration for Base networks
networks: {
  base: {
    url: 'https://mainnet.base.org',
    chainId: 8453,
    accounts: [process.env.PRIVATE_KEY]
  },
  'base-sepolia': {
    url: 'https://sepolia.base.org',
    chainId: 84532,
    accounts: [process.env.PRIVATE_KEY]
  }
}
```

## 🛠️ Development Tools

### Testing
```bash
# Run all tests
npx hardhat test

# Run specific test file
npx hardhat test test/EventTicket.test.js

# Generate coverage report
npx hardhat coverage
```

### Deployment
```bash
# Compile contracts
npx hardhat compile

# Deploy to testnet
npm run deploy:base-sepolia

# Deploy to mainnet
npm run deploy:base

# Verify contracts
npm run verify:base
```

### Frontend Development
```bash
# Start development server
npm run dev

# Build for production
npm run build

# Start production server
npm start
```

## 📊 Contract Addresses

### Base Mainnet
- **EventTicket**: `TBD`
- **TicketMarketplace**: `TBD`

### Base Sepolia Testnet
- **EventTicket**: `TBD`
- **TicketMarketplace**: `TBD`

*Note: Contract addresses will be updated after deployment*

## 🤝 Contributing

### Documentation Updates
1. Fork the repository
2. Create a feature branch
3. Update documentation
4. Submit a pull request

### Code Contributions
1. Follow the existing code style
2. Add comprehensive tests
3. Update documentation
4. Ensure all tests pass

## 📞 Support

### Community Resources
- **GitHub Issues**: Report bugs and request features
- **Discord**: Join our community for discussions
- **Documentation**: Comprehensive guides and examples

### Getting Help
1. Check the documentation first
2. Search existing GitHub issues
3. Create a new issue with detailed information
4. Join our Discord for community support

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](../LICENSE) file for details.

## 🔗 Additional Resources

### External Links
- [Base Network Documentation](https://docs.base.org/)
- [OpenZeppelin Contracts](https://docs.openzeppelin.com/contracts/)
- [Hardhat Documentation](https://hardhat.org/docs)
- [Wagmi Documentation](https://wagmi.sh/)
- [RainbowKit Documentation](https://www.rainbowkit.com/)

### Tutorials
- [Building on Base](https://docs.base.org/building-with-base/)
- [NFT Development Guide](https://docs.openzeppelin.com/contracts/4.x/erc721)
- [Web3 Frontend Development](https://wagmi.sh/examples)

---

*Last updated: [Current Date]*
*Version: 1.0.0*