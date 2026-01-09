# Documentation Index

Welcome to the NFT Event Ticketing System documentation. This comprehensive guide covers all aspects of the system, from smart contract APIs to user guides and tutorials.

## 📚 Documentation Structure

### Core Documentation
- **[API Documentation](./API.md)** - Complete smart contract API reference with usage examples
- **[API Reference](./API-Reference.md)** - Quick reference, error codes, and optimization tips
- **[Frontend Integration](./Frontend-Integration.md)** - React/Next.js integration guide

### User Guides
- **[Getting Started](./user-guides/getting-started.md)** - Complete beginner's guide to NFT ticketing
- **[Wallet Setup](./user-guides/wallet-setup.md)** - Detailed wallet configuration and security
- **[User Onboarding](./user-guides/onboarding.md)** - Role-specific onboarding paths
- **[Best Practices](./user-guides/best-practices.md)** - Optimization strategies for all users
- **[FAQ](./user-guides/faq.md)** - Frequently asked questions and answers
- **[Troubleshooting](./user-guides/troubleshooting.md)** - Technical issue resolution

### Tutorials
- **[Quick Start](./tutorials/quick-start.md)** - Get up and running in 15 minutes
- **[Event Organizer Tutorial](./tutorials/event-organizer-tutorial.md)** - Complete event creation guide
- **[Ticket Buyer Tutorial](./tutorials/ticket-buyer-tutorial.md)** - Purchasing and managing tickets
- **[Marketplace Tutorial](./tutorials/marketplace-tutorial.md)** - Buying and selling on secondary market
- **[Venue Staff Tutorial](./tutorials/venue-staff-tutorial.md)** - Ticket verification and troubleshooting
- **[Video Scripts](./tutorials/video-scripts.md)** - Scripts for creating video tutorials

### Quick Links

#### For New Users
- [Getting Started Guide](./user-guides/getting-started.md)
- [Quick Start Tutorial](./tutorials/quick-start.md)
- [Wallet Setup Guide](./user-guides/wallet-setup.md)
- [User Onboarding](./user-guides/onboarding.md)

#### For Event Organizers
- [Event Organizer Tutorial](./tutorials/event-organizer-tutorial.md)
- [Creating Events](./API.md#createevent)
- [Managing Tickets](./API.md#mintticket)
- [Setting Up Royalties](./API.md#setroyaltyinfo)
- [Best Practices for Organizers](./user-guides/best-practices.md#for-event-organizers)

#### For Ticket Buyers
- [Ticket Buyer Tutorial](./tutorials/ticket-buyer-tutorial.md)
- [Purchasing Tickets](./API.md#mintticket)
- [Transferring Tickets](./API.md#ticket-transfers)
- [Marketplace Trading](./tutorials/marketplace-tutorial.md)

#### For Venue Staff
- [Venue Staff Tutorial](./tutorials/venue-staff-tutorial.md)
- [Ticket Verification](./API.md#verifyticket)
- [QR Code Integration](./API.md#qr-code-integration)
- [Troubleshooting Guide](./user-guides/troubleshooting.md)

#### For Developers
- [Smart Contract Functions](./API.md#eventticket-contract)
- [Usage Examples](./API.md#usage-examples)
- [Integration Guide](./API.md#integration-guide)
- [Frontend Components](./Frontend-Integration.md#component-examples)

## 🚀 Getting Started

### New to NFT Tickets?
1. **[Read Getting Started Guide](./user-guides/getting-started.md)** - Understand the basics
2. **[Follow Quick Start Tutorial](./tutorials/quick-start.md)** - Get up and running in 15 minutes
3. **[Set Up Your Wallet](./user-guides/wallet-setup.md)** - Secure wallet configuration
4. **[Complete Onboarding](./user-guides/onboarding.md)** - Role-specific guidance

### For Developers

#### 1. Smart Contract Deployment
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

### User Documentation
Comprehensive guides for all user types, from complete beginners to advanced users.

**User Guides:**
- Complete setup and security guides
- Best practices and optimization strategies
- Troubleshooting and problem resolution
- Frequently asked questions

**Tutorials:**
- Step-by-step instructions for specific tasks
- Role-based learning paths
- Quick start guides for immediate use
- Video tutorial scripts

### Technical Documentation
Detailed technical information for developers and integrators.

**Smart Contract API:**
- Contract deployment and configuration
- Event creation and management
- Ticket minting and verification
- Marketplace operations
- Royalty management

**Integration Examples:**
Real-world examples for different programming languages and frameworks.

**Covered Languages:**
- JavaScript/TypeScript (Node.js, React, Next.js)
- Python (Web3.py)
- Solidity (Contract integration)

**Frontend Integration:**
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

### Self-Help Resources
- **[FAQ](./user-guides/faq.md)**: Common questions and answers
- **[Troubleshooting Guide](./user-guides/troubleshooting.md)**: Technical issue resolution
- **[Best Practices](./user-guides/best-practices.md)**: Optimization strategies
- **[Video Tutorials](./tutorials/video-scripts.md)**: Visual learning resources

### Community Resources
- **GitHub Issues**: Report bugs and request features
- **Discord**: Join our community for discussions
- **Documentation**: Comprehensive guides and examples

### Getting Help
1. Check the [FAQ](./user-guides/faq.md) first
2. Try the [Troubleshooting Guide](./user-guides/troubleshooting.md)
3. Search existing GitHub issues
4. Create a new issue with detailed information
5. Join our Discord for community support

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](../LICENSE) file for details.

## 🔗 Additional Resources

### External Links
- [Base Network Documentation](https://docs.base.org/)
- [OpenZeppelin Contracts](https://docs.openzeppelin.com/contracts/)
- [Hardhat Documentation](https://hardhat.org/docs)
- [Wagmi Documentation](https://wagmi.sh/)
- [RainbowKit Documentation](https://www.rainbowkit.com/)

### Learning Resources
- [Building on Base](https://docs.base.org/building-with-base/)
- [NFT Development Guide](https://docs.openzeppelin.com/contracts/4.x/erc721)
- [Web3 Frontend Development](https://wagmi.sh/examples)
- [Blockchain Security Best Practices](https://consensys.github.io/smart-contract-best-practices/)

### Community Tutorials
- [Video Tutorial Scripts](./tutorials/video-scripts.md)
- [User Onboarding Paths](./user-guides/onboarding.md)
- [Best Practices Guide](./user-guides/best-practices.md)

---

*Last updated: December 2024*
*Version: 2.0.0 - Now with comprehensive user guides and tutorials*