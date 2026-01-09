# Troubleshooting Guide

Comprehensive solutions for common technical issues with the NFT Event Ticketing System.

## 🚨 Quick Emergency Solutions

### Can't Access Tickets for Event Today
1. **Check wallet connection** - Ensure connected to Base network
2. **Try different browser** - Use wallet's built-in browser
3. **Use backup QR code** - Check saved screenshots/emails
4. **Contact venue directly** - Show purchase confirmation
5. **Call event support** - Have ticket ID ready

### Transaction Stuck/Failed
1. **Check Base network status** - Visit status.base.org
2. **Increase gas fee** - Try transaction again with higher gas
3. **Wait for network** - High congestion may cause delays
4. **Use different wallet** - Try alternative wallet app
5. **Contact support** - Provide transaction hash

### Wallet Compromised
1. **Stop all transactions immediately**
2. **Transfer assets to new wallet**
3. **Revoke all approvals** - Use revoke.cash
4. **Change all passwords**
5. **Report to wallet provider**

## 💻 Wallet Connection Issues

### MetaMask Won't Connect

**Symptoms:**
- "Connect Wallet" button doesn't work
- MetaMask doesn't open when clicked
- Connection request not appearing

**Solutions:**

**Step 1: Basic Troubleshooting**
```
1. Refresh the page (Ctrl+F5 or Cmd+Shift+R)
2. Check if MetaMask is unlocked
3. Ensure you're on the correct website
4. Try clicking "Connect Wallet" again
```

**Step 2: Browser Issues**
```
1. Disable other wallet extensions temporarily
2. Clear browser cache and cookies
3. Disable ad blockers for the site
4. Try incognito/private browsing mode
```

**Step 3: MetaMask Reset**
```
1. Lock and unlock MetaMask
2. Disconnect from site in MetaMask settings
3. Restart browser completely
4. Try connecting again
```

**Step 4: Network Issues**
```
1. Check if you're on Base network
2. Switch to Ethereum mainnet, then back to Base
3. Remove and re-add Base network
4. Reset MetaMask network settings
```

### Wrong Network Selected

**Symptoms:**
- Transactions fail with network errors
- Balances show as zero
- Can't see your tickets

**Solutions:**
```
1. Open wallet (MetaMask/Coinbase Wallet)
2. Click network dropdown (top of wallet)
3. Select "Base" network
4. If Base not listed, add manually:
   - Network Name: Base
   - RPC URL: https://mainnet.base.org
   - Chain ID: 8453
   - Currency: ETH
   - Explorer: https://basescan.org
```

### Wallet Balance Issues

**Symptoms:**
- ETH balance shows as zero
- Can't pay for transactions
- "Insufficient funds" errors

**Solutions:**

**Check Actual Balance:**
```
1. Visit basescan.org
2. Enter your wallet address
3. Verify actual ETH balance
4. Check if funds are on different network
```

**Bridge Funds to Base:**
```
1. Go to bridge.base.org
2. Connect your wallet
3. Bridge ETH from Ethereum mainnet
4. Wait for confirmation (usually 5-10 minutes)
```

**Buy ETH Directly:**
```
1. Use Coinbase (easiest for Base)
2. Buy ETH and select Base network
3. Send to your wallet address
4. Wait for confirmation
```

## 🔗 Transaction Problems

### Transaction Failed

**Common Error Messages & Solutions:**

**"Transaction Reverted"**
```
Cause: Smart contract rejected transaction
Solutions:
1. Check if event is still active
2. Verify ticket availability
3. Ensure sufficient payment amount
4. Try again with higher gas limit
```

**"Insufficient Gas"**
```
Cause: Gas limit too low for transaction
Solutions:
1. Increase gas limit in wallet
2. Use "Fast" or "Aggressive" gas settings
3. Wait for network congestion to decrease
4. Try during off-peak hours
```

**"Nonce Too Low/High"**
```
Cause: Transaction ordering issue
Solutions:
1. Reset wallet account in settings
2. Clear pending transactions
3. Wait a few minutes and try again
4. Use different wallet temporarily
```

**"Network Error"**
```
Cause: Connection to blockchain failed
Solutions:
1. Check internet connection
2. Switch to different RPC endpoint
3. Try different browser/device
4. Wait and retry in few minutes
```

### Transaction Stuck (Pending)

**Symptoms:**
- Transaction shows "Pending" for long time
- New transactions won't go through
- Wallet seems frozen

**Solutions:**

**Method 1: Wait It Out**
```
1. Check Base network status
2. Wait 10-15 minutes
3. Transaction may complete automatically
4. Don't send duplicate transactions
```

**Method 2: Speed Up Transaction**
```
1. Find pending transaction in wallet
2. Click "Speed Up" or "Accelerate"
3. Increase gas price
4. Confirm new transaction
```

**Method 3: Cancel Transaction**
```
1. Find pending transaction in wallet
2. Click "Cancel" if available
3. Pay cancellation gas fee
4. Try original transaction again
```

**Method 4: Reset Account**
```
1. Go to MetaMask Settings > Advanced
2. Click "Reset Account"
3. Confirm reset (doesn't affect funds)
4. Try transaction again
```

### High Gas Fees

**When Gas Fees Are High:**
```
Current Base gas: Usually $0.25-2.00
High congestion: May reach $5-10
Emergency: Up to $20+ (rare)
```

**Strategies to Reduce Costs:**

**Timing Strategy:**
```
1. Check gas tracker (base-gas-tracker.com)
2. Wait for lower congestion periods
3. Avoid peak hours (US evening)
4. Try early morning or late night
```

**Technical Solutions:**
```
1. Use "Standard" gas setting instead of "Fast"
2. Manually set lower gas price
3. Batch multiple transactions together
4. Use gas optimization tools
```

## 🎫 Ticket Management Issues

### Can't See My Tickets

**Symptoms:**
- Tickets don't appear in wallet
- "My Tickets" section is empty
- NFTs not visible

**Solutions:**

**Check Wallet NFT Section:**
```
1. Open wallet app
2. Go to "NFTs" or "Collectibles" tab
3. Refresh or sync wallet
4. Check if custom tokens need to be added
```

**Verify Network:**
```
1. Ensure you're on Base network
2. Check transaction was successful
3. Look up transaction on basescan.org
4. Verify ticket was minted to your address
```

**Platform Sync Issues:**
```
1. Disconnect and reconnect wallet
2. Refresh browser page
3. Clear browser cache
4. Try different browser/device
```

**Import Token Manually:**
```
1. Get contract address from transaction
2. Add custom token in wallet
3. Use NFT contract address
4. Ticket should appear
```

### QR Code Not Displaying

**Symptoms:**
- QR code shows as blank/broken
- Error loading QR code
- QR code appears corrupted

**Solutions:**

**Browser Issues:**
```
1. Refresh page completely
2. Clear browser cache
3. Try different browser
4. Disable ad blockers
```

**Platform Issues:**
```
1. Disconnect and reconnect wallet
2. Try accessing from wallet browser
3. Check if ticket is properly minted
4. Contact support with ticket ID
```

**Generate Backup QR:**
```
1. Note down ticket ID number
2. Use blockchain explorer to verify ticket
3. Contact venue with ticket details
4. Use manual verification if needed
```

### Transfer/Sale Issues

**Can't Transfer Ticket:**

**Check Transfer Settings:**
```
1. Verify event allows transfers
2. Check if ticket is already used
3. Ensure you own the ticket
4. Confirm recipient address is correct
```

**Technical Issues:**
```
1. Approve marketplace contract first
2. Ensure sufficient gas for transfer
3. Check if ticket is currently listed
4. Try from different device/browser
```

**Can't List on Marketplace:**

**Common Causes:**
```
1. Transfers disabled by organizer
2. Ticket already used/transferred
3. Price exceeds maximum allowed
4. Marketplace not approved
```

**Solutions:**
```
1. Check event transfer policy
2. Verify ticket ownership
3. Set price within limits
4. Approve marketplace contract
```

## 🌐 Network and Connectivity

### Base Network Issues

**Symptoms:**
- Transactions extremely slow
- Network errors
- Can't connect to Base

**Check Network Status:**
```
1. Visit status.base.org
2. Check Base official Twitter
3. Look for maintenance announcements
4. Monitor community Discord
```

**Alternative Solutions:**
```
1. Switch to different RPC endpoint
2. Use backup network provider
3. Wait for network recovery
4. Try mobile data instead of WiFi
```

### RPC Connection Problems

**Symptoms:**
- "Network Error" messages
- Slow or failed requests
- Inconsistent behavior

**Solutions:**

**Change RPC Endpoint:**
```
Default: https://mainnet.base.org
Backup: https://base-mainnet.public.blastapi.io
Alternative: Use Alchemy or Infura RPC
```

**Update Network Settings:**
```
1. Remove current Base network
2. Add Base network with new RPC
3. Test connection
4. Switch back to Base network
```

### Internet Connectivity

**Symptoms:**
- Page won't load
- Transactions timeout
- Wallet won't sync

**Troubleshooting:**
```
1. Check internet connection speed
2. Try different WiFi network
3. Use mobile data as backup
4. Restart router/modem
5. Contact ISP if persistent
```

## 📱 Mobile-Specific Issues

### Mobile Wallet Problems

**Common Issues:**
- App crashes during transactions
- QR codes don't display properly
- Touch interface not responsive

**Solutions:**

**App Management:**
```
1. Force close and restart wallet app
2. Update to latest version
3. Restart phone completely
4. Clear app cache (Android)
```

**Display Issues:**
```
1. Increase screen brightness
2. Clean screen thoroughly
3. Try landscape orientation
4. Use different QR code app
```

**Performance Issues:**
```
1. Close other apps
2. Free up storage space
3. Check available RAM
4. Restart device
```

### QR Code Scanning Issues

**At Venue Entry:**

**Preparation:**
```
1. Charge phone to 100%
2. Increase screen brightness to maximum
3. Clean screen thoroughly
4. Have backup QR code ready
```

**Scanning Problems:**
```
1. Hold phone steady
2. Adjust distance (6-12 inches)
3. Try different angles
4. Use flashlight if dark
5. Show backup QR code
```

**Emergency Solutions:**
```
1. Show ticket ID to staff
2. Provide purchase confirmation
3. Use printed backup
4. Contact venue support
```

## 🔧 Advanced Troubleshooting

### Smart Contract Interactions

**Contract Call Failures:**

**Debug Steps:**
```
1. Check contract address is correct
2. Verify function parameters
3. Ensure sufficient gas limit
4. Check contract is not paused
```

**ABI Issues:**
```
1. Verify ABI matches contract
2. Check function signatures
3. Update to latest ABI version
4. Use verified contract on explorer
```

### Blockchain Explorer Investigation

**Using Basescan.org:**

**Transaction Analysis:**
```
1. Enter transaction hash
2. Check transaction status
3. Review gas usage
4. Examine event logs
```

**Address Investigation:**
```
1. Enter wallet address
2. Check ETH balance
3. Review transaction history
4. Verify NFT holdings
```

**Contract Verification:**
```
1. Look up contract address
2. Check if verified
3. Review contract code
4. Examine recent transactions
```

### Data Recovery

**Lost Wallet Access:**

**Recovery Methods:**
```
1. Use seed phrase to restore
2. Import private key
3. Use hardware wallet recovery
4. Contact wallet support
```

**Backup Strategies:**
```
1. Write down seed phrase securely
2. Store in multiple safe locations
3. Use hardware wallet for large amounts
4. Test recovery process regularly
```

## 📞 When to Contact Support

### Self-Help First
Try these steps before contacting support:
1. Check this troubleshooting guide
2. Search FAQ for your issue
3. Ask in community Discord
4. Check network status pages

### Contact Support When:
- Funds are at risk
- Critical event day issues
- Suspected security breach
- Technical issues persist after troubleshooting

### Information to Provide:
```
- Wallet address
- Transaction hash (if applicable)
- Error messages (screenshots)
- Steps to reproduce issue
- Device and browser information
- Network and wallet type
```

### Support Channels:
- **Emergency**: Event day hotline
- **Urgent**: Email support with "URGENT" in subject
- **General**: Community Discord or regular email
- **Technical**: GitHub issues for bugs

---

**Remember**: Most issues can be resolved with basic troubleshooting. When in doubt, try the simplest solutions first (refresh, reconnect, restart) before moving to advanced techniques.