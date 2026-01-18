# API Reference

## Quick Reference

### EventTicket Contract

| Function | Description | Gas Estimate |
|----------|-------------|--------------|
| `createEvent()` | Create new event | ~150,000 |
| `mintTicket()` | Purchase ticket | ~120,000 |
| `verifyTicket()` | Verify at venue | ~45,000 |
| `transferFrom()` | Transfer ticket | ~85,000 |

### TicketMarketplace Contract

| Function | Description | Gas Estimate |
|----------|-------------|--------------|
| `listTicket()` | List for sale | ~75,000 |
| `buyTicket()` | Purchase from marketplace | ~150,000 |
| `cancelListing()` | Cancel listing | ~35,000 |
| `setRoyaltyInfo()` | Set royalties | ~50,000 |

## Error Codes

### EventTicket Errors

| Error | Code | Description |
|-------|------|-------------|
| `Event not active` | E001 | Event doesn't exist or is inactive |
| `Sold out` | E002 | No tickets remaining |
| `Insufficient payment` | E003 | Payment below ticket price |
| `Ticket does not exist` | E004 | Invalid ticket ID |
| `Ticket already used` | E005 | Ticket already verified |
| `Ticket not transferable` | E006 | Event doesn't allow transfers |

### TicketMarketplace Errors

| Error | Code | Description |
|-------|------|-------------|
| `Not token owner` | M001 | Caller doesn't own the ticket |
| `Not approved` | M002 | Marketplace not approved for transfer |
| `Price must be greater than 0` | M003 | Invalid listing price |
| `Listing not active` | M004 | Listing cancelled or sold |
| `Insufficient payment` | M005 | Payment below listing price |
| `Cannot buy own listing` | M006 | Seller cannot buy their own ticket |
| `Not authorized` | M007 | Not seller or contract owner |
| `Royalty too high` | M008 | Royalty exceeds 10% |
| `Fee too high` | M009 | Platform fee exceeds 10% |

## Gas Optimization Tips

### For Event Organizers

1. **Batch Operations**: Create multiple events in a single transaction when possible
2. **Optimize Event Data**: Keep descriptions concise to reduce storage costs
3. **Set Reasonable Limits**: Higher ticket counts increase gas costs

### For Ticket Buyers

1. **Approve Once**: Use `setApprovalForAll()` for multiple marketplace interactions
2. **Buy Early**: Gas prices may increase closer to event dates
3. **Check Estimates**: Use `estimateGas()` before transactions

### For Marketplace Users

1. **Bundle Listings**: List multiple tickets in sequence to optimize gas
2. **Cancel Strategically**: Only cancel if necessary due to gas costs
3. **Monitor Fees**: Platform and royalty fees affect total costs

## Rate Limits

### Recommended Limits

- **Event Creation**: 10 per hour per address
- **Ticket Minting**: 50 per hour per address
- **Marketplace Listings**: 100 per hour per address
- **API Calls**: 1000 per hour per IP

### Implementation Example

```javascript
const rateLimiter = {
  eventCreation: new Map(),
  ticketMinting: new Map(),
  
  checkLimit(address, action, limit) {
    const key = `${address}-${action}`;
    const now = Date.now();
    const hour = 60 * 60 * 1000;
    
    if (!this[action].has(key)) {
      this[action].set(key, []);
    }
    
    const timestamps = this[action].get(key);
    const recentTimestamps = timestamps.filter(t => now - t < hour);
    
    if (recentTimestamps.length >= limit) {
      throw new Error(`Rate limit exceeded for ${action}`);
    }
    
    recentTimestamps.push(now);
    this[action].set(key, recentTimestamps);
    return true;
  }
};
```

## Security Considerations

### Smart Contract Security

1. **Reentrancy Protection**: All payable functions use `nonReentrant` modifier
2. **Access Control**: Owner-only functions for critical operations
3. **Input Validation**: All parameters validated before processing
4. **Safe Math**: Using Solidity 0.8+ built-in overflow protection

### Frontend Security

1. **Input Sanitization**: Always sanitize user inputs
2. **Transaction Validation**: Verify transaction parameters before signing
3. **Error Handling**: Implement proper error handling for all contract calls
4. **Rate Limiting**: Implement client-side rate limiting

### API Security

```javascript
// Example security middleware
const securityMiddleware = {
  validateAddress(req, res, next) {
    const { address } = req.params;
    if (!ethers.utils.isAddress(address)) {
      return res.status(400).json({ error: 'Invalid address format' });
    }
    next();
  },
  
  sanitizeInput(req, res, next) {
    for (const key in req.body) {
      if (typeof req.body[key] === 'string') {
        req.body[key] = req.body[key].replace(/[<>]/g, '');
      }
    }
    next();
  },
  
  checkOrigin(req, res, next) {
    const allowedOrigins = process.env.ALLOWED_ORIGINS?.split(',') || [];
    const origin = req.headers.origin;
    
    if (allowedOrigins.includes(origin)) {
      res.setHeader('Access-Control-Allow-Origin', origin);
    }
    next();
  }
};
```

## Performance Optimization

### Contract Optimization

1. **Storage Layout**: Optimize struct packing to reduce gas costs
2. **Event Indexing**: Use indexed parameters for efficient filtering
3. **View Functions**: Use view/pure functions for read operations
4. **Batch Operations**: Combine multiple operations when possible

### Frontend Optimization

1. **Connection Pooling**: Reuse provider connections
2. **Caching**: Cache contract instances and frequently accessed data
3. **Lazy Loading**: Load contract data on demand
4. **Pagination**: Implement pagination for large datasets

```javascript
// Optimized contract interaction
class OptimizedContractService {
  constructor() {
    this.contractCache = new Map();
    this.dataCache = new Map();
  }
  
  getContract(address, abi, signer) {
    const key = `${address}-${signer.address}`;
    if (!this.contractCache.has(key)) {
      this.contractCache.set(key, new ethers.Contract(address, abi, signer));
    }
    return this.contractCache.get(key);
  }
  
  async getCachedData(key, fetchFunction, ttl = 300000) { // 5 min TTL
    const cached = this.dataCache.get(key);
    if (cached && Date.now() - cached.timestamp < ttl) {
      return cached.data;
    }
    
    const data = await fetchFunction();
    this.dataCache.set(key, { data, timestamp: Date.now() });
    return data;
  }
}
```

## Monitoring and Analytics

### Event Monitoring

```javascript
// Event monitoring setup
const eventMonitor = {
  async setupEventListeners(contract) {
    // Monitor event creation
    contract.on('EventCreated', (eventId, name, organizer, event) => {
      this.logEvent('EVENT_CREATED', {
        eventId: eventId.toString(),
        name,
        organizer,
        blockNumber: event.blockNumber,
        transactionHash: event.transactionHash
      });
    });
    
    // Monitor ticket sales
    contract.on('TicketMinted', (ticketId, eventId, buyer, event) => {
      this.logEvent('TICKET_SOLD', {
        ticketId: ticketId.toString(),
        eventId: eventId.toString(),
        buyer,
        blockNumber: event.blockNumber,
        transactionHash: event.transactionHash
      });
    });
    
    // Monitor verifications
    contract.on('TicketVerified', (ticketId, verifier, event) => {
      this.logEvent('TICKET_VERIFIED', {
        ticketId: ticketId.toString(),
        verifier,
        blockNumber: event.blockNumber,
        transactionHash: event.transactionHash
      });
    });
  },
  
  logEvent(type, data) {
    console.log(`[${new Date().toISOString()}] ${type}:`, data);
    // Send to analytics service
    this.sendToAnalytics(type, data);
  },
  
  async sendToAnalytics(type, data) {
    // Implementation depends on analytics service
    try {
      await fetch('/api/analytics', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ type, data, timestamp: Date.now() })
      });
    } catch (error) {
      console.error('Analytics error:', error);
    }
  }
};
```

### Metrics Collection

```javascript
// Metrics collection
const metricsCollector = {
  metrics: {
    totalEvents: 0,
    totalTicketsSold: 0,
    totalRevenue: BigInt(0),
    averageTicketPrice: BigInt(0),
    verificationRate: 0
  },
  
  async updateMetrics() {
    // Collect on-chain data
    const events = await this.getAllEvents();
    const tickets = await this.getAllTickets();
    
    this.metrics.totalEvents = events.length;
    this.metrics.totalTicketsSold = tickets.length;
    this.metrics.totalRevenue = tickets.reduce(
      (sum, ticket) => sum + ticket.price, 
      BigInt(0)
    );
    
    if (tickets.length > 0) {
      this.metrics.averageTicketPrice = this.metrics.totalRevenue / BigInt(tickets.length);
    }
    
    const verifiedTickets = tickets.filter(t => t.isVerified).length;
    this.metrics.verificationRate = verifiedTickets / tickets.length;
  },
  
  getMetrics() {
    return {
      ...this.metrics,
      totalRevenue: this.metrics.totalRevenue.toString(),
      averageTicketPrice: this.metrics.averageTicketPrice.toString()
    };
  }
};
```

## Testing Guidelines

### Unit Testing

```javascript
// Test structure example
describe('Contract Function', function () {
  beforeEach(async function () {
    // Setup test environment
  });
  
  describe('Success Cases', function () {
    it('should handle normal operation', async function () {
      // Test implementation
    });
    
    it('should handle edge cases', async function () {
      // Test implementation
    });
  });
  
  describe('Failure Cases', function () {
    it('should revert with invalid input', async function () {
      // Test implementation
    });
    
    it('should revert with unauthorized access', async function () {
      // Test implementation
    });
  });
});
```

### Integration Testing

```javascript
// Integration test example
describe('End-to-End Ticket Flow', function () {
  it('should complete full ticket lifecycle', async function () {
    // 1. Create event
    const eventId = await createEvent();
    
    // 2. Mint ticket
    const ticketId = await mintTicket(eventId);
    
    // 3. List on marketplace
    const listingId = await listTicket(ticketId);
    
    // 4. Buy from marketplace
    await buyTicket(listingId);
    
    // 5. Verify ticket
    await verifyTicket(ticketId);
    
    // Verify final state
    const ticket = await contract.tickets(ticketId);
    expect(ticket.isUsed).to.be.true;
  });
});
```

### Load Testing

```javascript
// Load testing example
describe('Load Testing', function () {
  it('should handle multiple concurrent operations', async function () {
    const promises = [];
    
    // Create multiple events concurrently
    for (let i = 0; i < 10; i++) {
      promises.push(createEvent(`Event ${i}`));
    }
    
    const eventIds = await Promise.all(promises);
    expect(eventIds).to.have.length(10);
  });
  
  it('should handle high ticket volume', async function () {
    const eventId = await createEvent('High Volume Event');
    const promises = [];
    
    // Mint many tickets concurrently
    for (let i = 0; i < 100; i++) {
      promises.push(mintTicket(eventId, i + 1));
    }
    
    const ticketIds = await Promise.all(promises);
    expect(ticketIds).to.have.length(100);
  });
});
```

## Deployment Checklist

### Pre-Deployment

- [ ] All tests passing
- [ ] Security audit completed
- [ ] Gas optimization verified
- [ ] Environment variables configured
- [ ] Network configuration verified
- [ ] Contract verification setup

### Deployment Steps

1. **Compile Contracts**
   ```bash
   npx hardhat compile
   ```

2. **Run Tests**
   ```bash
   npx hardhat test
   ```

3. **Deploy to Testnet**
   ```bash
   npx hardhat run scripts/deploy.js --network base-sepolia
   ```

4. **Verify Contracts**
   ```bash
   npx hardhat verify --network base-sepolia <contract-address>
   ```

5. **Deploy to Mainnet**
   ```bash
   npx hardhat run scripts/deploy.js --network base
   ```

### Post-Deployment

- [ ] Contract addresses updated in frontend
- [ ] API endpoints configured
- [ ] Monitoring setup
- [ ] Documentation updated
- [ ] Team notified
- [ ] Users notified

## Support and Maintenance

### Common Issues

1. **Transaction Failures**
   - Check gas limits
   - Verify contract state
   - Confirm user permissions

2. **Frontend Connection Issues**
   - Verify network configuration
   - Check wallet connection
   - Confirm contract addresses

3. **Performance Issues**
   - Monitor gas usage
   - Check for network congestion
   - Optimize query patterns

### Maintenance Tasks

1. **Regular Updates**
   - Monitor contract events
   - Update documentation
   - Review security practices

2. **Performance Monitoring**
   - Track gas usage trends
   - Monitor transaction success rates
   - Analyze user behavior

3. **Security Reviews**
   - Regular security audits
   - Monitor for vulnerabilities
   - Update dependencies