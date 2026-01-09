@echo off
echo Creating GitHub issues for NFT Event Ticketing System MVP...

REM Project Setup Issues
gh issue create --title "Setup project structure and initial configuration" --body "Create the basic project structure with contracts/, frontend/, scripts/, and test/ directories. Initialize package.json and basic configuration files." --label "setup,epic"

gh issue create --title "Configure Hardhat development environment" --body "Setup Hardhat configuration for local development, testing, and deployment. Include network configurations for localhost, testnet, and mainnet." --label "setup,development"

gh issue create --title "Setup Next.js frontend application" --body "Initialize Next.js application with TypeScript support. Configure basic project structure with components/, pages/, and utils/ directories." --label "setup,frontend"

gh issue create --title "Configure environment variables and secrets" --body "Setup environment variable configuration for private keys, Infura project ID, and Etherscan API key. Create .env.example file." --label "setup,security"

gh issue create --title "Setup IPFS integration for metadata storage" --body "Configure IPFS client for storing and retrieving NFT metadata. Setup pinning service integration." --label "setup,storage"

REM Smart Contract Development
gh issue create --title "Create EventTicket.sol base contract" --body "Develop the main EventTicket contract inheriting from ERC721. Include basic NFT functionality and event-specific metadata." --label "smart-contract,core"

gh issue create --title "Implement createEvent function" --body "Add functionality to create new events with parameters: name, date, venue, ticket price, max supply, and transfer restrictions." --label "smart-contract,feature"

gh issue create --title "Implement mintTicket function" --body "Add ticket purchasing functionality that mints NFTs to buyers. Include payment processing and ticket limit validation." --label "smart-contract,feature"

gh issue create --title "Add event metadata and ticket information storage" --body "Implement data structures to store event details, ticket information, and mapping between token IDs and events." --label "smart-contract,core"

gh issue create --title "Implement setEventDetails function" --body "Add functionality for event organizers to update event information before the event starts." --label "smart-contract,feature"

gh issue create --title "Create ticket verification system" --body "Implement verifyTicket function for venue entry validation. Include QR code generation and verification logic." --label "smart-contract,feature"

gh issue create --title "Add transfer restrictions and anti-scalping measures" --body "Implement transfer controls including price caps, transfer delays, and organizer-defined restrictions." --label "smart-contract,feature"

gh issue create --title "Create TicketMarketplace.sol contract" --body "Develop secondary marketplace contract for ticket resales with royalty distribution to event organizers." --label "smart-contract,marketplace"

gh issue create --title "Implement listForSale marketplace function" --body "Add functionality for ticket holders to list their tickets for resale with price validation." --label "smart-contract,marketplace"

gh issue create --title "Implement buyFromMarketplace function" --body "Add functionality to purchase tickets from the secondary marketplace with automatic royalty distribution." --label "smart-contract,marketplace"

gh issue create --title "Add royalty system with setRoyaltyInfo" --body "Implement EIP-2981 royalty standard for automatic royalty payments to event organizers on secondary sales." --label "smart-contract,feature"

gh issue create --title "Create access control and ownership management" --body "Implement role-based access control for event organizers, venue operators, and administrators." --label "smart-contract,security"

gh issue create --title "Add emergency functions and circuit breakers" --body "Implement pause functionality and emergency withdrawal mechanisms for contract security." --label "smart-contract,security"

REM Testing
gh issue create --title "Write comprehensive unit tests for EventTicket contract" --body "Create test suite covering all EventTicket functions including edge cases and error conditions." --label "testing,smart-contract"

gh issue create --title "Write unit tests for TicketMarketplace contract" --body "Create test suite for marketplace functionality including listing, buying, and royalty distribution." --label "testing,smart-contract"

gh issue create --title "Add integration tests for contract interactions" --body "Test interactions between EventTicket and TicketMarketplace contracts in various scenarios." --label "testing,integration"

gh issue create --title "Create gas optimization tests" --body "Analyze and optimize gas usage for all contract functions. Document gas costs for different operations." --label "testing,optimization"

REM Frontend Development
gh issue create --title "Setup Web3 connection with Ethers.js" --body "Implement wallet connection functionality supporting MetaMask and other Web3 wallets." --label "frontend,web3"

gh issue create --title "Create event creation interface" --body "Build UI for event organizers to create new events with all required parameters and metadata." --label "frontend,feature"

gh issue create --title "Implement ticket purchasing interface" --body "Create user interface for browsing events and purchasing tickets with Web3 integration." --label "frontend,feature"

gh issue create --title "Build event browsing and discovery page" --body "Create homepage with event listings, search functionality, and filtering options." --label "frontend,feature"

gh issue create --title "Create user dashboard for ticket management" --body "Build interface for users to view their owned tickets, transfer tickets, and list for resale." --label "frontend,feature"

gh issue create --title "Implement QR code generation and display" --body "Generate QR codes for tickets and create interface for displaying them for venue entry." --label "frontend,feature"

gh issue create --title "Build secondary marketplace interface" --body "Create UI for browsing and purchasing tickets from the secondary market." --label "frontend,marketplace"

gh issue create --title "Add ticket verification interface for venues" --body "Create venue operator interface for scanning and verifying ticket QR codes." --label "frontend,verification"

gh issue create --title "Implement responsive design with Tailwind CSS" --body "Ensure all interfaces are mobile-responsive and follow consistent design patterns." --label "frontend,ui"

gh issue create --title "Add loading states and error handling" --body "Implement proper loading indicators, error messages, and user feedback throughout the application." --label "frontend,ux"

gh issue create --title "Create wallet connection and network switching" --body "Implement wallet connection flow with network detection and switching capabilities." --label "frontend,web3"

REM Deployment and DevOps
gh issue create --title "Create deployment scripts for local development" --body "Write deployment scripts for local Hardhat network with sample data for testing." --label "deployment,development"

gh issue create --title "Setup testnet deployment configuration" --body "Configure deployment for Polygon Mumbai or Ethereum Goerli testnet with verification." --label "deployment,testnet"

gh issue create --title "Create contract verification scripts" --body "Implement automatic contract verification on Etherscan/Polygonscan after deployment." --label "deployment,verification"

gh issue create --title "Setup frontend deployment pipeline" --body "Configure deployment for Next.js application with environment-specific configurations." --label "deployment,frontend"

REM Documentation and Final MVP Tasks
gh issue create --title "Create API documentation for smart contracts" --body "Document all contract functions, events, and data structures with usage examples." --label "documentation"

gh issue create --title "Write user guide and tutorials" --body "Create comprehensive user documentation covering event creation, ticket purchasing, and marketplace usage." --label "documentation"

gh issue create --title "Add security audit checklist" --body "Create security review checklist and perform initial security assessment of smart contracts." --label "security,audit"

gh issue create --title "Implement basic analytics and monitoring" --body "Add basic event tracking for user interactions and contract usage statistics." --label "analytics,monitoring"

gh issue create --title "Create MVP demo and testing scenarios" --body "Prepare demo scenarios showcasing all MVP features and create testing checklist for final validation." --label "demo,testing"

echo All 40 issues created successfully!
pause