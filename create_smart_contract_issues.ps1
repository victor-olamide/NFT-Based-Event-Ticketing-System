# Add GitHub CLI to PATH
$env:PATH += ";C:\Program Files\GitHub CLI"

# Create 10 smart contract specific issues
$smartContractIssues = @(
    @{title="Create EventTicket.sol ERC721 base contract"; body="Develop the main EventTicket contract inheriting from OpenZeppelin's ERC721. Include basic NFT functionality with event-specific metadata structure and Base network optimization."},
    @{title="Implement createEvent function with Base gas optimization"; body="Add functionality to create new events with parameters: name, date, venue, ticket price, max supply, and transfer restrictions. Optimize for Base network's low gas costs."},
    @{title="Implement mintTicket function with payment processing"; body="Add ticket purchasing functionality that mints NFTs to buyers. Include ETH payment processing, ticket limit validation, and event capacity checks."},
    @{title="Add comprehensive event and ticket data structures"; body="Implement structs and mappings to store event details, ticket information, pricing tiers, and relationships between token IDs and events."},
    @{title="Create ticket verification and QR code system"; body="Implement verifyTicket function for venue entry validation. Include unique ticket hash generation for QR codes and anti-fraud mechanisms."},
    @{title="Implement transfer restrictions and anti-scalping controls"; body="Add transfer controls including maximum resale price caps, transfer cooldown periods, and organizer-defined restrictions to prevent ticket scalping."},
    @{title="Create TicketMarketplace.sol secondary market contract"; body="Develop secondary marketplace contract for ticket resales with automatic royalty distribution to event organizers and Base network integration."},
    @{title="Implement EIP-2981 royalty standard for creator earnings"; body="Add royalty system using EIP-2981 standard for automatic royalty payments to event organizers on all secondary sales with configurable percentages."},
    @{title="Add role-based access control and security features"; body="Implement OpenZeppelin's AccessControl for event organizers, venue operators, and administrators. Include pause functionality and emergency controls."},
    @{title="Create comprehensive smart contract test suite"; body="Write complete test coverage for all contract functions including edge cases, security scenarios, gas optimization tests, and Base network specific testing."}
)

foreach ($issue in $smartContractIssues) {
    & "C:\Program Files\GitHub CLI\gh.exe" issue create --title $issue.title --body $issue.body
    Start-Sleep -Seconds 1
}

Write-Host "All 10 smart contract issues created successfully!"