# Wallet Setup Guide

Complete guide to setting up and using Web3 wallets for NFT Event Ticketing on Base network.

## 🎯 Overview

This guide covers everything you need to know about Web3 wallets, from choosing the right one to advanced security practices.

### What You'll Learn
- How to choose the right wallet
- Step-by-step setup instructions
- Adding Base network
- Getting ETH on Base
- Security best practices
- Troubleshooting common issues

## 📱 Choosing Your Wallet

### Recommended Wallets

**MetaMask** ⭐ Most Popular
- **Pros**: Widely supported, browser + mobile, extensive features
- **Cons**: Can be complex for beginners
- **Best For**: Desktop users, experienced crypto users
- **Download**: metamask.io

**Coinbase Wallet** ⭐ Beginner Friendly
- **Pros**: User-friendly, native Base support, easy onboarding
- **Cons**: Less customization options
- **Best For**: Beginners, Coinbase users
- **Download**: wallet.coinbase.com

**Trust Wallet** ⭐ Mobile First
- **Pros**: Mobile-optimized, built-in DApp browser, multi-chain
- **Cons**: Limited desktop support
- **Best For**: Mobile users, multi-chain users
- **Download**: trustwallet.com

**Rainbow Wallet** ⭐ iOS Focused
- **Pros**: Beautiful interface, iOS optimized, easy to use
- **Cons**: Limited to iOS, fewer features
- **Best For**: iPhone users, design-conscious users
- **Download**: rainbow.me

### Wallet Comparison

| Feature | MetaMask | Coinbase Wallet | Trust Wallet | Rainbow |
|---------|----------|-----------------|--------------|---------|
| Browser Extension | ✅ | ❌ | ❌ | ❌ |
| Mobile App | ✅ | ✅ | ✅ | ✅ (iOS only) |
| Base Network | ✅ | ✅ | ✅ | ✅ |
| Hardware Wallet | ✅ | ❌ | ❌ | ❌ |
| DApp Browser | ✅ | ✅ | ✅ | ✅ |
| Beginner Friendly | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |

## 🔧 MetaMask Setup (Desktop)

### Step 1: Install MetaMask

1. **Visit Official Website**
   - Go to [metamask.io](https://metamask.io)
   - Click "Download" button
   - Select your browser (Chrome, Firefox, Edge, Brave)

2. **Install Extension**
   - Click "Add to Chrome" (or your browser)
   - Confirm installation
   - Pin extension to toolbar for easy access

3. **Initial Setup**
   - Click MetaMask icon in browser
   - Click "Get Started"
   - Choose "Create a Wallet"

### Step 2: Create Your Wallet

1. **Set Password**
   ```
   Requirements:
   - At least 8 characters
   - Mix of letters, numbers, symbols
   - Don't use personal information
   - Store securely (password manager recommended)
   ```

2. **Backup Seed Phrase** ⚠️ CRITICAL STEP
   ```
   Your seed phrase is 12 words that can recover your wallet
   
   IMPORTANT:
   - Write down all 12 words in exact order
   - Store in multiple safe locations
   - NEVER share with anyone
   - NEVER store digitally (photos, cloud, etc.)
   - This is your ONLY way to recover your wallet
   ```

3. **Verify Seed Phrase**
   - MetaMask will ask you to confirm words
   - Select words in correct order
   - This ensures you wrote them down correctly

### Step 3: Add Base Network

1. **Open Network Settings**
   - Click network dropdown (top of MetaMask)
   - Click "Add Network"
   - Select "Add a network manually"

2. **Enter Base Network Details**
   ```
   Network Name: Base
   New RPC URL: https://mainnet.base.org
   Chain ID: 8453
   Currency Symbol: ETH
   Block Explorer URL: https://basescan.org
   ```

3. **Save and Switch**
   - Click "Save"
   - MetaMask will switch to Base network
   - You should see "Base" in network dropdown

### ✅ MetaMask Setup Complete
- Extension installed and configured
- Wallet created with secure password
- Seed phrase backed up safely
- Base network added and active

## 📱 Coinbase Wallet Setup (Mobile)

### Step 1: Download App

1. **Get the App**
   - iOS: Search "Coinbase Wallet" in App Store
   - Android: Search "Coinbase Wallet" in Play Store
   - Download official app (check developer: Coinbase)

2. **Open and Start Setup**
   - Open Coinbase Wallet app
   - Tap "Create new wallet"
   - Accept terms and conditions

### Step 2: Secure Your Wallet

1. **Create Username**
   - Choose unique username
   - This is for easy wallet identification
   - Can be changed later

2. **Backup Wallet** ⚠️ CRITICAL
   ```
   Coinbase Wallet offers multiple backup options:
   
   Option 1: Cloud Backup (Easier)
   - Encrypted backup to iCloud/Google Drive
   - Protected by your device security
   - Easier to recover
   
   Option 2: Manual Backup (More Secure)
   - Write down 12-word recovery phrase
   - Store in multiple safe locations
   - Complete control over backup
   ```

3. **Set Up Biometrics**
   - Enable Face ID/Touch ID/Fingerprint
   - Adds extra security layer
   - Makes app access faster

### Step 3: Configure for Base

1. **Access Networks**
   - Tap settings (gear icon)
   - Select "Active Networks"
   - Find and enable "Base"

2. **Switch to Base**
   - Return to main screen
   - Tap network name at top
   - Select "Base" from list
   - Confirm you're on Base network

### ✅ Coinbase Wallet Setup Complete
- App installed and wallet created
- Backup completed (cloud or manual)
- Biometric security enabled
- Base network configured and active

## 💰 Getting ETH on Base

### Method 1: Bridge from Ethereum (Most Common)

**Requirements:**
- ETH on Ethereum mainnet
- ~$10-50 in ETH for gas fees
- 10-15 minutes for completion

**Steps:**
1. **Visit Base Bridge**
   - Go to [bridge.base.org](https://bridge.base.org)
   - Connect your wallet
   - Ensure you're on Ethereum mainnet

2. **Bridge ETH**
   ```
   Recommended amounts:
   - First time: $50-100 worth of ETH
   - Regular use: $20-50 worth of ETH
   - Heavy use: $100+ worth of ETH
   ```

3. **Complete Bridge**
   - Enter amount to bridge
   - Review fees (usually $10-30)
   - Confirm transaction
   - Wait for completion (5-15 minutes)

### Method 2: Buy Directly on Base (Coinbase Users)

**Requirements:**
- Coinbase account
- Bank account or debit card linked
- Coinbase Wallet app

**Steps:**
1. **Buy on Coinbase**
   - Open Coinbase app (not Coinbase Wallet)
   - Buy ETH
   - Select "Base" as network
   - Complete purchase

2. **Send to Wallet**
   - Copy your Coinbase Wallet address
   - Send ETH from Coinbase to Coinbase Wallet
   - Ensure Base network is selected
   - Confirm transaction

### Method 3: Use On-Ramps (Credit/Debit Card)

**Available Services:**
- **MoonPay**: Integrated in many wallets
- **Transak**: Direct Base purchases
- **Ramp**: Credit card to Base
- **Banxa**: Multiple payment methods

**Steps:**
1. **Access On-Ramp**
   - Look for "Buy" button in wallet
   - Or visit on-ramp website directly
   - Connect your wallet

2. **Purchase ETH**
   - Select Base network
   - Enter purchase amount
   - Provide payment details
   - Complete KYC if required

### Method 4: Receive from Friend

**Steps:**
1. **Get Your Address**
   - Open wallet
   - Copy your wallet address
   - Share with sender

2. **Verify Receipt**
   - Check Base network is selected
   - Wait for transaction confirmation
   - ETH should appear in wallet

## 🔒 Security Best Practices

### Seed Phrase Security

**DO:**
- Write on paper with pen/pencil
- Store in multiple safe locations
- Use fireproof/waterproof storage
- Consider metal backup plates
- Test recovery process periodically

**DON'T:**
- Take photos of seed phrase
- Store in cloud services
- Share with anyone
- Store on computer/phone
- Use online seed phrase generators

### Password Security

**Strong Password Requirements:**
```
- At least 12 characters
- Mix of uppercase/lowercase
- Include numbers and symbols
- Unique to this wallet
- Not based on personal information
```

**Password Management:**
- Use password manager (1Password, Bitwarden)
- Enable two-factor authentication where possible
- Don't reuse passwords
- Update regularly

### Device Security

**Mobile Security:**
- Keep OS updated
- Use screen lock (PIN/biometric)
- Don't jailbreak/root device
- Install apps only from official stores
- Enable remote wipe capability

**Computer Security:**
- Keep browser updated
- Use antivirus software
- Don't use public computers for wallet access
- Log out when finished
- Clear browser data regularly

### Transaction Security

**Before Every Transaction:**
- Verify website URL is correct
- Check transaction details carefully
- Confirm recipient address
- Review gas fees
- Never rush transactions

**Red Flags:**
- Unexpected transaction requests
- Extremely high gas fees
- Unfamiliar contract interactions
- Pressure to act quickly
- Requests for seed phrase

## 🔧 Advanced Wallet Features

### Hardware Wallet Integration

**Supported Hardware Wallets:**
- Ledger Nano S/X
- Trezor Model T
- KeepKey

**Benefits:**
- Private keys never leave device
- Protection against malware
- Secure transaction signing
- Best security for large amounts

**Setup Process:**
1. Purchase hardware wallet from official source
2. Set up device with its own seed phrase
3. Connect to MetaMask or other software wallet
4. Use hardware wallet to sign transactions

### Multi-Signature Wallets

**What is Multi-Sig:**
- Requires multiple signatures for transactions
- Shared control between multiple parties
- Enhanced security for organizations
- Protection against single point of failure

**Use Cases:**
- Business/organization funds
- Shared event organizer accounts
- High-value ticket collections
- Family/group wallets

### Wallet Recovery

**If You Lose Access:**

**With Seed Phrase:**
1. Download wallet app on new device
2. Select "Import wallet" or "Restore"
3. Enter 12-word seed phrase in order
4. Set new password
5. Wallet and funds restored

**Without Seed Phrase:**
- Funds are permanently lost
- No way to recover wallet
- This is why backup is critical
- Contact wallet support for guidance only

## 📱 Mobile Wallet Tips

### Battery Management
- Keep phone charged during events
- Bring portable charger
- Enable low power mode if needed
- Close unnecessary apps

### Screen Optimization
- Increase brightness for QR codes
- Clean screen regularly
- Use landscape mode if helpful
- Disable auto-lock temporarily

### Network Management
- Download offline maps to venue
- Have backup internet (mobile data)
- Test wallet functionality beforehand
- Know venue WiFi details

### Backup Access
- Save QR codes to photos
- Email QR codes to yourself
- Share with trusted companion
- Print physical backup

## 🆘 Common Issues & Solutions

### Can't Connect Wallet
```
1. Refresh browser page
2. Clear browser cache
3. Disable other wallet extensions
4. Try incognito/private mode
5. Restart browser
```

### Wrong Network
```
1. Open wallet
2. Click network dropdown
3. Select "Base"
4. If not listed, add manually
5. Refresh page
```

### Transaction Failed
```
1. Check ETH balance for gas
2. Increase gas limit
3. Wait for network congestion to clear
4. Try again with higher gas price
5. Contact support if persistent
```

### Wallet Locked
```
1. Click wallet extension
2. Enter password to unlock
3. If password forgotten, use seed phrase
4. Import wallet with seed phrase
5. Set new password
```

## 📞 Getting Help

### Wallet-Specific Support
- **MetaMask**: support.metamask.io
- **Coinbase Wallet**: help.coinbase.com
- **Trust Wallet**: community.trustwallet.com
- **Rainbow**: rainbow.me/support

### Community Resources
- Discord communities
- Reddit forums
- YouTube tutorials
- Official documentation

### Emergency Contacts
- Wallet customer support
- Platform support team
- Community moderators
- Technical support hotlines

---

**Remember**: Your wallet is your responsibility. Take time to understand security practices and always prioritize the safety of your seed phrase and private keys.