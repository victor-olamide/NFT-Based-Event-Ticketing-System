# Add GitHub CLI to PATH
$env:PATH += ";C:\Program Files\GitHub CLI"

# Authenticate with GitHub
& "C:\Program Files\GitHub CLI\gh.exe" auth login --web

# Create all 40 issues
$issues = @(
    @{title="Setup project structure and initial configuration"; body="Create the basic project structure with contracts/, frontend/, scripts/, and test/ directories. Initialize package.json and basic configuration files."; labels="setup,epic"},
    @{title="Configure Hardhat development environment"; body="Setup Hardhat configuration for local development, testing, and deployment. Include network configurations for localhost, testnet, and mainnet."; labels="setup,development"},
    @{title="Setup Next.js frontend application"; body="Initialize Next.js application with TypeScript support. Configure basic project structure with components/, pages/, and utils/ directories."; labels="setup,frontend"},
    @{title="Configure environment variables and secrets"; body="Setup environment variable configuration for private keys, Infura project ID, and Etherscan API key. Create .env.example file."; labels="setup,security"},
    @{title="Setup IPFS integration for metadata storage"; body="Configure IPFS client for storing and retrieving NFT metadata. Setup pinning service integration."; labels="setup,storage"},
    @{title="Create EventTicket.sol base contract"; body="Develop the main EventTicket contract inheriting from ERC721. Include basic NFT functionality and event-specific metadata."; labels="smart-contract,core"},
    @{title="Implement createEvent function"; body="Add functionality to create new events with parameters: name, date, venue, ticket price, max supply, and transfer restrictions."; labels="smart-contract,feature"},
    @{title="Implement mintTicket function"; body="Add ticket purchasing functionality that mints NFTs to buyers. Include payment processing and ticket limit validation."; labels="smart-contract,feature"},
    @{title="Add event metadata and ticket information storage"; body="Implement data structures to store event details, ticket information, and mapping between token IDs and events."; labels="smart-contract,core"},
    @{title="Implement setEventDetails function"; body="Add functionality for event organizers to update event information before the event starts."; labels="smart-contract,feature"},
    @{title="Create ticket verification system"; body="Implement verifyTicket function for venue entry validation. Include QR code generation and verification logic."; labels="smart-contract,feature"},
    @{title="Add transfer restrictions and anti-scalping measures"; body="Implement transfer controls including price caps, transfer delays, and organizer-defined restrictions."; labels="smart-contract,feature"},
    @{title="Create TicketMarketplace.sol contract"; body="Develop secondary marketplace contract for ticket resales with royalty distribution to event organizers."; labels="smart-contract,marketplace"},
    @{title="Implement listForSale marketplace function"; body="Add functionality for ticket holders to list their tickets for resale with price validation."; labels="smart-contract,marketplace"},
    @{title="Implement buyFromMarketplace function"; body="Add functionality to purchase tickets from the secondary marketplace with automatic royalty distribution."; labels="smart-contract,marketplace"},
    @{title="Add royalty system with setRoyaltyInfo"; body="Implement EIP-2981 royalty standard for automatic royalty payments to event organizers on secondary sales."; labels="smart-contract,feature"},
    @{title="Create access control and ownership management"; body="Implement role-based access control for event organizers, venue operators, and administrators."; labels="smart-contract,security"},
    @{title="Add emergency functions and circuit breakers"; body="Implement pause functionality and emergency withdrawal mechanisms for contract security."; labels="smart-contract,security"},
    @{title="Write comprehensive unit tests for EventTicket contract"; body="Create test suite covering all EventTicket functions including edge cases and error conditions."; labels="testing,smart-contract"},
    @{title="Write unit tests for TicketMarketplace contract"; body="Create test suite for marketplace functionality including listing, buying, and royalty distribution."; labels="testing,smart-contract"},
    @{title="Add integration tests for contract interactions"; body="Test interactions between EventTicket and TicketMarketplace contracts in various scenarios."; labels="testing,integration"},
    @{title="Create gas optimization tests"; body="Analyze and optimize gas usage for all contract functions. Document gas costs for different operations."; labels="testing,optimization"},
    @{title="Setup Web3 connection with Ethers.js"; body="Implement wallet connection functionality supporting MetaMask and other Web3 wallets."; labels="frontend,web3"},
    @{title="Create event creation interface"; body="Build UI for event organizers to create new events with all required parameters and metadata."; labels="frontend,feature"},
    @{title="Implement ticket purchasing interface"; body="Create user interface for browsing events and purchasing tickets with Web3 integration."; labels="frontend,feature"},
    @{title="Build event browsing and discovery page"; body="Create homepage with event listings, search functionality, and filtering options."; labels="frontend,feature"},
    @{title="Create user dashboard for ticket management"; body="Build interface for users to view their owned tickets, transfer tickets, and list for resale."; labels="frontend,feature"},
    @{title="Implement QR code generation and display"; body="Generate QR codes for tickets and create interface for displaying them for venue entry."; labels="frontend,feature"},
    @{title="Build secondary marketplace interface"; body="Create UI for browsing and purchasing tickets from the secondary market."; labels="frontend,marketplace"},
    @{title="Add ticket verification interface for venues"; body="Create venue operator interface for scanning and verifying ticket QR codes."; labels="frontend,verification"},
    @{title="Implement responsive design with Tailwind CSS"; body="Ensure all interfaces are mobile-responsive and follow consistent design patterns."; labels="frontend,ui"},
    @{title="Add loading states and error handling"; body="Implement proper loading indicators, error messages, and user feedback throughout the application."; labels="frontend,ux"},
    @{title="Create wallet connection and network switching"; body="Implement wallet connection flow with network detection and switching capabilities."; labels="frontend,web3"},
    @{title="Create deployment scripts for local development"; body="Write deployment scripts for local Hardhat network with sample data for testing."; labels="deployment,development"},
    @{title="Setup testnet deployment configuration"; body="Configure deployment for Polygon Mumbai or Ethereum Goerli testnet with verification."; labels="deployment,testnet"},
    @{title="Create contract verification scripts"; body="Implement automatic contract verification on Etherscan/Polygonscan after deployment."; labels="deployment,verification"},
    @{title="Setup frontend deployment pipeline"; body="Configure deployment for Next.js application with environment-specific configurations."; labels="deployment,frontend"},
    @{title="Create API documentation for smart contracts"; body="Document all contract functions, events, and data structures with usage examples."; labels="documentation"},
    @{title="Write user guide and tutorials"; body="Create comprehensive user documentation covering event creation, ticket purchasing, and marketplace usage."; labels="documentation"},
    @{title="Add security audit checklist"; body="Create security review checklist and perform initial security assessment of smart contracts."; labels="security,audit"},
    @{title="Implement basic analytics and monitoring"; body="Add basic event tracking for user interactions and contract usage statistics."; labels="analytics,monitoring"},
    @{title="Create MVP demo and testing scenarios"; body="Prepare demo scenarios showcasing all MVP features and create testing checklist for final validation."; labels="demo,testing"}
)

foreach ($issue in $issues) {
    & "C:\Program Files\GitHub CLI\gh.exe" issue create --title $issue.title --body $issue.body --label $issue.labels
    Start-Sleep -Seconds 1
}

Write-Host "All 40 issues created successfully!"