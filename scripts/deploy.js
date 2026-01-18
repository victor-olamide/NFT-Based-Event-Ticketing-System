const { ethers } = require('hardhat');
const fs = require('fs');
const path = require('path');

async function main() {
  console.log('Starting deployment to Base network with gas optimization...');
  
  const [deployer] = await ethers.getSigners();
  console.log('Deploying contracts with account:', deployer.address);
  console.log('Account balance:', (await deployer.provider.getBalance(deployer.address)).toString());

  // Deploy EventTicket contract with Base optimization
  console.log('\nDeploying EventTicket contract with Base gas optimization...');
  const EventTicket = await ethers.getContractFactory('EventTicket');
  
  // Estimate gas for deployment
  const deploymentData = EventTicket.getDeployTransaction();
  const gasEstimate = await deployer.estimateGas(deploymentData);
  console.log('Estimated gas for EventTicket deployment:', gasEstimate.toString());
  
  const eventTicket = await EventTicket.deploy({
    gasLimit: gasEstimate.mul(110).div(100) // 10% buffer for Base optimization
  });
  await eventTicket.waitForDeployment();
  console.log('EventTicket deployed to:', await eventTicket.getAddress());

  // Deploy TicketMarketplace contract
  console.log('\nDeploying TicketMarketplace contract with Base optimization...');
  const TicketMarketplace = await ethers.getContractFactory('TicketMarketplace');
  const feeRecipient = process.env.FEE_RECIPIENT_ADDRESS || deployer.address;
  
  const marketplaceDeploymentData = TicketMarketplace.getDeployTransaction(
    await eventTicket.getAddress(),
    feeRecipient
  );
  const marketplaceGasEstimate = await deployer.estimateGas(marketplaceDeploymentData);
  console.log('Estimated gas for TicketMarketplace deployment:', marketplaceGasEstimate.toString());
  
  const marketplace = await TicketMarketplace.deploy(
    await eventTicket.getAddress(),
    feeRecipient,
    {
      gasLimit: marketplaceGasEstimate.mul(110).div(100) // 10% buffer
    }
  );
  await marketplace.waitForDeployment();
  console.log('TicketMarketplace deployed to:', await marketplace.getAddress());

  // Save deployment addresses
  const deploymentInfo = {
    network: network.name,
    chainId: network.config.chainId,
    contracts: {
      EventTicket: {
        address: await eventTicket.getAddress(),
        transactionHash: eventTicket.deploymentTransaction().hash
      },
      TicketMarketplace: {
        address: await marketplace.getAddress(),
        transactionHash: marketplace.deploymentTransaction().hash
      }
    },
    deployer: deployer.address,
    feeRecipient: feeRecipient,
    timestamp: new Date().toISOString(),
    blockNumber: await ethers.provider.getBlockNumber(),
    gasOptimization: {
      eventTicketGas: gasEstimate.toString(),
      marketplaceGas: marketplaceGasEstimate.toString(),
      baseNetwork: true
    }
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
    await eventTicket.deploymentTransaction().wait(6);
    await marketplace.deploymentTransaction().wait(6);

    console.log('Verifying contracts on Basescan...');
    
    try {
      await hre.run('verify:verify', {
        address: await eventTicket.getAddress(),
        constructorArguments: [],
      });
      console.log('EventTicket contract verified');
    } catch (error) {
      console.log('EventTicket verification failed:', error.message);
    }

    try {
      await hre.run('verify:verify', {
        address: await marketplace.getAddress(),
        constructorArguments: [await eventTicket.getAddress(), feeRecipient],
      });
      console.log('TicketMarketplace contract verified');
    } catch (error) {
      console.log('TicketMarketplace verification failed:', error.message);
    }
  }

  console.log('\n=== Base Network Deployment Summary ===');
  console.log('Network:', network.name);
  console.log('EventTicket:', await eventTicket.getAddress());
  console.log('TicketMarketplace:', await marketplace.getAddress());
  console.log('Deployer:', deployer.address);
  console.log('Fee Recipient:', feeRecipient);
  console.log('Gas Optimization: Enabled for Base L2');
  console.log('=======================================');
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error('Deployment failed:', error);
    process.exit(1);
  });