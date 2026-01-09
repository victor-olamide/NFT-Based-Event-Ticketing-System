# Clarity Smart Contracts

This directory contains Clarity smart contracts for the Stacks blockchain integration.

## Contracts

### smet-reward.clar
A reward distribution contract that manages SMET token rewards for users.

**Features:**
- Reward pool initialization (owner only)
- User reward claiming with validation
- Anti-double-claim protection
- Maximum reward amount limits
- Comprehensive error handling

**Constants:**
- `CONTRACT_OWNER`: The contract deployer address
- `ERR_UNAUTHORIZED`: Authorization error (u100)
- `ERR_INSUFFICIENT_BALANCE`: Insufficient pool balance (u101)
- `ERR_INVALID_AMOUNT`: Invalid amount error (u102)
- `ERR_ALREADY_CLAIMED`: Already claimed error (u103)
- `MAX_REWARD_AMOUNT`: Maximum claimable amount (1,000,000)

**Public Functions:**
- `initialize-reward-pool(amount)`: Initialize reward pool (owner only)
- `claim-reward(amount)`: Claim rewards (users)

**Read-Only Functions:**
- `get-reward-pool()`: Get current pool balance
- `get-user-reward(user)`: Get user's claimed amount
- `has-claimed(user)`: Check if user has claimed
- `get-total-distributed()`: Get total distributed rewards

## Deployment

Deploy to Stacks testnet or mainnet using Clarinet or other Clarity deployment tools.

## Testing

Test contracts using Clarinet test framework before deployment.