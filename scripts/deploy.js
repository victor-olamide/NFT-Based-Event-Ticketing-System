const { ethers } = require('hardhat');

async function main() {
  console.log('Deploying EventTicket contract with mintTicket payment processing...');
  
  const [deployer] = await ethers.getSigners();
  console.log('Deploying with account:', deployer.address);
  console.log('Account balance:', (await deployer.provider.getBalance(deployer.address)).toString());

  const EventTicket = await ethers.getContractFactory('EventTicket');
  const eventTicket = await EventTicket.deploy();
  await eventTicket.waitForDeployment();
  
  console.log('EventTicket deployed to:', await eventTicket.getAddress());
  
  // Test deployment by creating a sample event
  console.log('Creating sample event...');
  const eventDate = Math.floor(Date.now() / 1000) + 86400; // 1 day from now
  const tx = await eventTicket.createEvent(
    "Sample Event",
    eventDate,
    "Sample Venue",
    ethers.parseEther("0.1"),
    100
  );
  await tx.wait();
  
  console.log('Sample event created with ID: 1');
  console.log('Deployment completed successfully!');
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error('Deployment failed:', error);
    process.exit(1);
  });