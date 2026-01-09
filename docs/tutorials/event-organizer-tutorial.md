# Event Organizer Tutorial

Learn how to create and manage events on the NFT Event Ticketing System. This step-by-step tutorial covers everything from setup to post-event management.

## 📋 Prerequisites

- Web3 wallet with ETH on Base network
- Basic understanding of blockchain transactions
- Event details ready (name, date, venue, etc.)

## 🎯 Tutorial Overview

1. [Connect Your Wallet](#1-connect-your-wallet)
2. [Create Your First Event](#2-create-your-first-event)
3. [Configure Ticket Settings](#3-configure-ticket-settings)
4. [Set Up Anti-Scalping Protection](#4-set-up-anti-scalping-protection)
5. [Configure Royalties](#5-configure-royalties)
6. [Launch Your Event](#6-launch-your-event)
7. [Monitor Sales](#7-monitor-sales)
8. [Manage Your Event](#8-manage-your-event)

## 1. Connect Your Wallet

### Step 1: Visit the Platform
1. Go to the NFT Event Ticketing platform
2. Click "Connect Wallet" in the top right
3. Choose your wallet (MetaMask, Coinbase Wallet, etc.)

### Step 2: Approve Connection
1. Your wallet will open
2. Click "Connect" to approve
3. Ensure you're on Base network
4. Confirm you have sufficient ETH for gas fees

### ✅ Success Indicator
- Your wallet address appears in the top right
- Network shows "Base" 
- ETH balance is visible

## 2. Create Your First Event

### Step 1: Access Event Creation
1. Click "Create Event" button
2. You'll see the event creation form
3. Have your event details ready

### Step 2: Fill Basic Information

**Event Name**
```
Example: "Base Music Festival 2024"
```
- Keep it clear and descriptive
- Avoid special characters
- Maximum 100 characters

**Description**
```
Example: "Join us for an unforgettable night of music featuring top artists from around the world. Experience the future of live entertainment on Base network."
```
- Explain what attendees can expect
- Include key highlights
- Maximum 500 characters

**Venue**
```
Example: "Madison Square Garden, New York, NY"
```
- Include full address if possible
- Add landmark references
- Consider accessibility information

**Event Date & Time**
- Use the date/time picker
- Set in your local timezone
- Consider setup/breakdown time
- Must be in the future

### Step 3: Upload Event Image (Optional)
1. Click "Upload Image"
2. Choose high-quality image (recommended: 1200x630px)
3. Ensure you have rights to use the image
4. Image will be stored on IPFS

## 3. Configure Ticket Settings

### Total Tickets Available
```
Example: 5000 tickets
```
- Consider venue capacity
- Account for VIP/reserved sections
- Can't be changed after creation

### Ticket Price
```
Example: 0.1 ETH (~$200 at current rates)
```
- Set in ETH (Base network native currency)
- Consider current ETH price
- Factor in gas fees for buyers
- Price is fixed once set

### Seat Numbering
**Option 1: Sequential (1, 2, 3, ...)**
- Simple and straightforward
- Good for general admission
- Easy to manage

**Option 2: Custom Sections**
- VIP: 1-100
- General: 101-1000
- Balcony: 1001-1500
- More complex but organized

## 4. Set Up Anti-Scalping Protection

### Maximum Transfer Price
```
Example: 0.15 ETH (50% markup limit)
```
- Set maximum resale price
- Prevents excessive scalping
- Recommended: 20-50% above original price
- Protects your fans from price gouging

### Transfer Settings
**Allow Transfers: Yes/No**

**If Yes:**
- Tickets can be resold on marketplace
- Enables secondary market
- You earn royalties on resales

**If No:**
- Tickets locked to original buyer
- Prevents all resales
- Maximum anti-scalping protection

### Recommended Settings by Event Type

**High-Demand Concerts**
- Max Transfer Price: +25-50%
- Transfers: Enabled
- Royalty: 5-10%

**Exclusive Events**
- Max Transfer Price: +10-25%
- Transfers: Disabled
- Focus on attendee verification

**Community Events**
- Max Transfer Price: +0-20%
- Transfers: Enabled
- Royalty: 2-5%

## 5. Configure Royalties

### Royalty Percentage
```
Recommended: 5% (range: 0-10%)
```
- You earn this % on every resale
- Passive income from secondary market
- Higher % may discourage resales

### Royalty Recipient
- Usually your wallet address
- Can be different address (e.g., band's wallet)
- Can be multi-sig wallet for organizations
- Cannot be changed after setting

### Royalty Calculator
```
Original Price: 0.1 ETH
Resale Price: 0.15 ETH
Royalty (5%): 0.0075 ETH
Platform Fee (2.5%): 0.00375 ETH
Seller Receives: 0.13875 ETH
```

## 6. Launch Your Event

### Step 1: Review All Settings
- Double-check all information
- Verify dates and times
- Confirm pricing and limits
- Review anti-scalping settings

### Step 2: Estimate Gas Costs
- Event creation: ~$1-3 in gas
- Check current Base network fees
- Ensure sufficient ETH balance

### Step 3: Submit Transaction
1. Click "Create Event"
2. Review transaction in wallet
3. Confirm gas fee is reasonable
4. Click "Confirm" in wallet

### Step 4: Wait for Confirmation
- Transaction typically confirms in 2-5 seconds on Base
- You'll see confirmation message
- Event ID will be generated
- Event is now live for ticket sales

### ✅ Success Indicators
- Event appears in your dashboard
- Unique event ID assigned
- Ticket sales are active
- Event page is accessible

## 7. Monitor Sales

### Dashboard Overview
Access your organizer dashboard to see:

**Sales Metrics**
- Total tickets sold
- Revenue generated
- Sales velocity (tickets/hour)
- Remaining inventory

**Real-Time Updates**
- New ticket purchases
- Marketplace activity
- Royalty earnings
- Gas fee costs

**Analytics**
- Sales by time period
- Popular seat sections
- Buyer demographics (wallet age)
- Resale activity

### Key Metrics to Watch

**Sales Velocity**
```
Target: Sell out 2-4 weeks before event
Monitor: Tickets sold per day
Action: Adjust marketing if slow
```

**Resale Activity**
```
Monitor: Secondary market prices
Watch: Excessive markup attempts
Action: Communicate with community
```

**Revenue Tracking**
```
Primary Sales: Ticket price × tickets sold
Royalty Income: % of resale transactions
Total Revenue: Primary + royalties
```

## 8. Manage Your Event

### Pre-Event Management

**Marketing Integration**
- Share event page URL
- Promote unique NFT aspect
- Highlight anti-scalping protection
- Emphasize secure, fraud-proof tickets

**Community Communication**
- Explain how NFT tickets work
- Provide wallet setup guides
- Share QR code instructions
- Address common concerns

**Technical Preparation**
- Test QR scanning equipment
- Train venue staff
- Prepare backup verification
- Set up monitoring systems

### During Event

**Entry Management**
1. Staff scans QR codes
2. System verifies ticket authenticity
3. Ticket marked as "used"
4. Entry granted/denied instantly

**Real-Time Monitoring**
- Track entry rates
- Monitor for issues
- Verify ticket authenticity
- Handle edge cases

### Post-Event

**Analytics Review**
- Total attendance vs. tickets sold
- No-show rates
- Entry timing patterns
- Technical issues encountered

**Financial Summary**
- Primary sales revenue
- Royalty earnings
- Total gas costs
- Net profit calculation

**Community Follow-Up**
- Thank attendees
- Share event highlights
- Gather feedback
- Plan future events

## 💡 Pro Tips

### Pricing Strategy
- Research similar events
- Consider your audience
- Factor in gas fees
- Test with small events first

### Marketing NFT Tickets
- Emphasize security benefits
- Highlight collectible aspect
- Explain anti-fraud protection
- Show environmental benefits (vs. paper)

### Community Building
- Create Discord/Telegram groups
- Share behind-the-scenes content
- Engage with ticket holders
- Build loyalty for future events

### Technical Best Practices
- Test everything on testnet first
- Have backup plans ready
- Monitor gas prices
- Keep documentation handy

## 🚨 Common Issues & Solutions

### High Gas Fees
**Problem**: Network congestion increases costs
**Solution**: 
- Wait for lower congestion
- Use gas price trackers
- Consider off-peak hours

### Slow Sales
**Problem**: Tickets not selling as expected
**Solution**:
- Review pricing strategy
- Increase marketing efforts
- Engage community
- Consider promotional pricing

### Technical Issues
**Problem**: Platform or wallet problems
**Solution**:
- Check network status
- Try different browser
- Contact support
- Have backup plans

### Scalping Concerns
**Problem**: Tickets being resold at high prices
**Solution**:
- Communicate transfer limits
- Engage with community
- Monitor marketplace
- Adjust future settings

## 📊 Success Metrics

### Primary Metrics
- **Sell-out Time**: How quickly tickets sell
- **Revenue**: Total income generated
- **Attendance Rate**: Tickets used vs. sold
- **Community Engagement**: Social media activity

### Secondary Metrics
- **Resale Volume**: Secondary market activity
- **Price Stability**: Resale vs. original price
- **Technical Issues**: Problems encountered
- **User Satisfaction**: Feedback scores

## 🎉 Next Steps

After your first successful event:

1. **Analyze Performance**: Review all metrics and feedback
2. **Plan Improvements**: Identify areas for enhancement
3. **Build Community**: Maintain relationships with attendees
4. **Scale Up**: Consider larger or multiple events
5. **Innovate**: Explore new features and capabilities

### Advanced Features to Explore
- **Multi-tier Pricing**: VIP, General, Student tickets
- **Dynamic Pricing**: Prices that change over time
- **Bundled Packages**: Tickets + merchandise
- **Loyalty Programs**: Rewards for repeat attendees
- **Cross-Event Promotions**: Link multiple events

---

**Congratulations!** You've learned how to create and manage events on the NFT Event Ticketing System. Start with a small test event to get comfortable with the process, then scale up to larger events as you gain experience.

**Need help?** Check out our [FAQ](../user-guides/faq.md) or join our [Discord community](https://discord.gg/nft-ticketing) for support.