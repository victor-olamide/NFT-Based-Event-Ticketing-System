const { ethers } = require('hardhat');
const fs = require('fs');
const path = require('path');

async function main() {
  console.log('Starting deployment to Base network...');
  
  const [deployer] = await ethers.getSigners();
  console.log('Deploying contracts with account:', deployer.address);
  console.log('Account balance:', (await deployer.getBalance()).toString());

  // Deploy EventTicket contract
  console.log('\nDeploying EventTicket contract...');
  const EventTicket = await ethers.getContractFactory('EventTicket');
  const eventTicket = await EventTicket.deploy();
  await eventTicket.deployed();
  console.log('EventTicket deployed to:', eventTicket.address);

  // Deploy TicketMarketplace contract
  console.log('\nDeploying TicketMarketplace contract...');
  const TicketMarketplace = await ethers.getContractFactory('TicketMarketplace');
  const feeRecipient = process.env.FEE_RECIPIENT_ADDRESS || deployer.address;
  const marketplace = await TicketMarketplace.deploy(
    eventTicket.address,
    feeRecipient
  );
  await marketplace.deployed();
  console.log('TicketMarketplace deployed to:', marketplace.address);

  // Save deployment addresses
  const deploymentInfo = {
    network: network.name,
    chainId: network.config.chainId,
    contracts: {
      EventTicket: {
        address: eventTicket.address,
        transactionHash: eventTicket.deployTransaction.hash
      },
      TicketMarketplace: {
        address: marketplace.address,
        transactionHash: marketplace.deployTransaction.hash
      }
    },
    deployer: deployer.address,
    feeRecipient: feeRecipient,
    timestamp: new Date().toISOString(),
    blockNumber: await ethers.provider.getBlockNumber()
  };

  // Write deployment info to file
  const deploymentPath = path.join(__dirname, '..', 'deployments', `${network.name}.json`);
  const deploymentDir = path.dirname(deploymentPath);
  
  if (!fs.existsSync(deploymentDir)) {
    fs.mkdirSync(deploymentDir, { recursive: true });
  }
  
  fs.writeFileSync(deploymentPath, JSON.stringify(deploymentInfo, null, 2));
  console.log(`\nDeployment info saved to: ${deploymentPath}`);

  // Verify contracts on Basescan (if not local network)
  if (network.name !== 'hardhat' && network.name !== 'localhost') {
    console.log('\nWaiting for block confirmations...');
    await eventTicket.deployTransaction.wait(6);
    await marketplace.deployTransaction.wait(6);

    console.log('Verifying contracts on Basescan...');
    
    try {
      await hre.run('verify:verify', {
        address: eventTicket.address,
        constructorArguments: [],
      });
      console.log('EventTicket contract verified');
    } catch (error) {
      console.log('EventTicket verification failed:', error.message);
    }

    try {
      await hre.run('verify:verify', {
        address: marketplace.address,
        constructorArguments: [eventTicket.address, feeRecipient],
      });
      console.log('TicketMarketplace contract verified');
    } catch (error) {
      console.log('TicketMarketplace verification failed:', error.message);
    }
  }

  console.log('\n=== Deployment Summary ===');
  console.log('Network:', network.name);
  console.log('EventTicket:', eventTicket.address);
  console.log('TicketMarketplace:', marketplace.address);
  console.log('Deployer:', deployer.address);
  console.log('Fee Recipient:', feeRecipient);
  console.log('==========================');
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error('Deployment failed:', error);
    process.exit(1);
  });