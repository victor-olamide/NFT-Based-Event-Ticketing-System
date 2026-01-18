const { expect } = require('chai');
const { ethers } = require('hardhat');
const { time } = require('@nomicfoundation/hardhat-network-helpers');

describe('TicketMarketplace', function () {
  let eventTicket;
  let marketplace;
  let owner;
  let organizer;
  let seller;
  let buyer;
  let feeRecipient;

  const eventData = {
    name: 'Test Event',
    description: 'Test Description',
    venue: 'Test Venue',
    totalTickets: 1000,
    ticketPrice: ethers.parseEther('0.1'),
    maxTransferPrice: ethers.parseEther('0.15'),
    transferable: true
  };

  beforeEach(async function () {
    [owner, organizer, seller, buyer, feeRecipient] = await ethers.getSigners();
    
    // Deploy EventTicket contract
    const EventTicket = await ethers.getContractFactory('EventTicket');
    eventTicket = await EventTicket.deploy();
    
    // Deploy TicketMarketplace contract
    const TicketMarketplace = await ethers.getContractFactory('TicketMarketplace');
    marketplace = await TicketMarketplace.deploy(
      await eventTicket.getAddress(),
      feeRecipient.address
    );

    // Create an event and mint a ticket
    eventData.date = (await time.latest()) + (30 * 24 * 60 * 60);
    
    await eventTicket.connect(organizer).createEvent(
      eventData.name,
      eventData.description,
      eventData.date,
      eventData.venue,
      eventData.totalTickets,
      eventData.ticketPrice,
      eventData.maxTransferPrice,
      eventData.transferable
    );

    await eventTicket.connect(seller).mintTicket(
      1, // eventId
      1, // seatNumber
      'QR_CODE_123',
      { value: eventData.ticketPrice }
    );
  });

  describe('Deployment', function () {
    it('Should set the correct ticket contract and fee recipient', async function () {
      expect(await marketplace.ticketContract()).to.equal(await eventTicket.getAddress());
      expect(await marketplace.feeRecipient()).to.equal(feeRecipient.address);
      expect(await marketplace.platformFee()).to.equal(250); // 2.5%
    });
  });

  describe('Listing Tickets', function () {
    it('Should list a ticket successfully', async function () {
      const listingPrice = ethers.parseEther('0.12');
      
      // Approve marketplace to transfer the ticket
      await eventTicket.connect(seller).approve(await marketplace.getAddress(), 1);
      
      const tx = await marketplace.connect(seller).listTicket(1, listingPrice);
      const receipt = await tx.wait();
      
      const ticketListedEvent = receipt.logs.find(
        log => log.fragment && log.fragment.name === 'TicketListed'
      );

      expect(ticketListedEvent.args.listingId).to.equal(1);
      expect(ticketListedEvent.args.tokenId).to.equal(1);
      expect(ticketListedEvent.args.seller).to.equal(seller.address);
      expect(ticketListedEvent.args.price).to.equal(listingPrice);

      const listing = await marketplace.getListing(1);
      expect(listing.tokenId).to.equal(1);
      expect(listing.seller).to.equal(seller.address);
      expect(listing.price).to.equal(listingPrice);
      expect(listing.active).to.be.true;
    });

    it('Should fail if not token owner', async function () {
      const listingPrice = ethers.parseEther('0.12');
      
      await expect(
        marketplace.connect(buyer).listTicket(1, listingPrice)
      ).to.be.revertedWith('Not token owner');
    });

    it('Should fail if not approved', async function () {
      const listingPrice = ethers.parseEther('0.12');
      
      await expect(
        marketplace.connect(seller).listTicket(1, listingPrice)
      ).to.be.revertedWith('Not approved');
    });

    it('Should fail if price is zero', async function () {
      await eventTicket.connect(seller).approve(await marketplace.getAddress(), 1);
      
      await expect(
        marketplace.connect(seller).listTicket(1, 0)
      ).to.be.revertedWith('Price must be greater than 0');
    });
  });

  describe('Buying Tickets', function () {
    beforeEach(async function () {
      const listingPrice = ethers.parseEther('0.12');
      await eventTicket.connect(seller).approve(await marketplace.getAddress(), 1);
      await marketplace.connect(seller).listTicket(1, listingPrice);
    });

    it('Should buy a ticket successfully', async function () {
      const listing = await marketplace.getListing(1);
      const listingPrice = listing.price;
      
      const sellerBalanceBefore = await ethers.provider.getBalance(seller.address);
      const feeRecipientBalanceBefore = await ethers.provider.getBalance(feeRecipient.address);
      
      const tx = await marketplace.connect(buyer).buyTicket(1, {
        value: listingPrice
      });
      
      const receipt = await tx.wait();
      const ticketSoldEvent = receipt.logs.find(
        log => log.fragment && log.fragment.name === 'TicketSold'
      );

      expect(ticketSoldEvent.args.listingId).to.equal(1);
      expect(ticketSoldEvent.args.tokenId).to.equal(1);
      expect(ticketSoldEvent.args.buyer).to.equal(buyer.address);
      expect(ticketSoldEvent.args.price).to.equal(listingPrice);

      // Check ownership transfer
      expect(await eventTicket.ownerOf(1)).to.equal(buyer.address);

      // Check listing is no longer active
      const updatedListing = await marketplace.getListing(1);
      expect(updatedListing.active).to.be.false;

      // Check payment distribution
      const platformFeeAmount = (listingPrice * 250n) / 10000n; // 2.5%
      const sellerAmount = listingPrice - platformFeeAmount;
      
      const sellerBalanceAfter = await ethers.provider.getBalance(seller.address);
      const feeRecipientBalanceAfter = await ethers.provider.getBalance(feeRecipient.address);
      
      expect(sellerBalanceAfter - sellerBalanceBefore).to.equal(sellerAmount);
      expect(feeRecipientBalanceAfter - feeRecipientBalanceBefore).to.equal(platformFeeAmount);
    });

    it('Should fail if listing is not active', async function () {
      // Cancel the listing first
      await marketplace.connect(seller).cancelListing(1);
      
      const listing = await marketplace.getListing(1);
      
      await expect(
        marketplace.connect(buyer).buyTicket(1, {
          value: listing.price
        })
      ).to.be.revertedWith('Listing not active');
    });

    it('Should fail if insufficient payment', async function () {
      const listing = await marketplace.getListing(1);
      const insufficientAmount = listing.price - ethers.parseEther('0.01');
      
      await expect(
        marketplace.connect(buyer).buyTicket(1, {
          value: insufficientAmount
        })
      ).to.be.revertedWith('Insufficient payment');
    });

    it('Should fail if buyer is the seller', async function () {
      const listing = await marketplace.getListing(1);
      
      await expect(
        marketplace.connect(seller).buyTicket(1, {
          value: listing.price
        })
      ).to.be.revertedWith('Cannot buy own listing');
    });

    it('Should refund excess payment', async function () {
      const listing = await marketplace.getListing(1);
      const overpayment = listing.price + ethers.parseEther('0.05');
      
      const buyerBalanceBefore = await ethers.provider.getBalance(buyer.address);
      
      const tx = await marketplace.connect(buyer).buyTicket(1, {
        value: overpayment
      });
      
      const receipt = await tx.wait();
      const gasUsed = receipt.gasUsed * receipt.gasPrice;
      const buyerBalanceAfter = await ethers.provider.getBalance(buyer.address);
      
      // Should only charge the listing price plus gas
      const expectedBalance = buyerBalanceBefore - listing.price - gasUsed;
      expect(buyerBalanceAfter).to.be.closeTo(expectedBalance, ethers.parseEther('0.001'));
    });
  });

  describe('Cancelling Listings', function () {
    beforeEach(async function () {
      const listingPrice = ethers.parseEther('0.12');
      await eventTicket.connect(seller).approve(await marketplace.getAddress(), 1);
      await marketplace.connect(seller).listTicket(1, listingPrice);
    });

    it('Should allow seller to cancel listing', async function () {
      const tx = await marketplace.connect(seller).cancelListing(1);
      const receipt = await tx.wait();
      
      const listingCancelledEvent = receipt.logs.find(
        log => log.fragment && log.fragment.name === 'ListingCancelled'
      );

      expect(listingCancelledEvent.args.listingId).to.equal(1);
      expect(listingCancelledEvent.args.tokenId).to.equal(1);

      const listing = await marketplace.getListing(1);
      expect(listing.active).to.be.false;
    });

    it('Should allow owner to cancel listing', async function () {
      await marketplace.connect(owner).cancelListing(1);
      
      const listing = await marketplace.getListing(1);
      expect(listing.active).to.be.false;
    });

    it('Should fail if not authorized', async function () {
      await expect(
        marketplace.connect(buyer).cancelListing(1)
      ).to.be.revertedWith('Not authorized');
    });

    it('Should fail if listing is not active', async function () {
      await marketplace.connect(seller).cancelListing(1);
      
      await expect(
        marketplace.connect(seller).cancelListing(1)
      ).to.be.revertedWith('Listing not active');
    });
  });

  describe('Royalty Management', function () {
    it('Should set royalty info correctly', async function () {
      const royaltyRecipient = organizer.address;
      const royaltyFraction = 500; // 5%
      
      const tx = await marketplace.connect(owner).setRoyaltyInfo(
        await eventTicket.getAddress(),
        royaltyRecipient,
        royaltyFraction
      );
      
      const receipt = await tx.wait();
      const royaltySetEvent = receipt.logs.find(
        log => log.fragment && log.fragment.name === 'RoyaltySet'
      );

      expect(royaltySetEvent.args.collection).to.equal(await eventTicket.getAddress());
      expect(royaltySetEvent.args.recipient).to.equal(royaltyRecipient);
      expect(royaltySetEvent.args.royaltyFraction).to.equal(royaltyFraction);

      const royaltyInfo = await marketplace.royalties(await eventTicket.getAddress());
      expect(royaltyInfo.recipient).to.equal(royaltyRecipient);
      expect(royaltyInfo.royaltyFraction).to.equal(royaltyFraction);
    });

    it('Should fail if royalty is too high', async function () {
      const royaltyFraction = 1500; // 15% - too high
      
      await expect(
        marketplace.connect(owner).setRoyaltyInfo(
          await eventTicket.getAddress(),
          organizer.address,
          royaltyFraction
        )
      ).to.be.revertedWith('Royalty too high');
    });

    it('Should distribute royalties correctly on sale', async function () {
      // Set up royalty
      const royaltyFraction = 500; // 5%
      await marketplace.connect(owner).setRoyaltyInfo(
        await eventTicket.getAddress(),
        organizer.address,
        royaltyFraction
      );

      // List and buy ticket
      const listingPrice = ethers.parseEther('0.12');
      await eventTicket.connect(seller).approve(await marketplace.getAddress(), 1);
      await marketplace.connect(seller).listTicket(1, listingPrice);

      const organizerBalanceBefore = await ethers.provider.getBalance(organizer.address);
      const sellerBalanceBefore = await ethers.provider.getBalance(seller.address);
      const feeRecipientBalanceBefore = await ethers.provider.getBalance(feeRecipient.address);

      await marketplace.connect(buyer).buyTicket(1, {
        value: listingPrice
      });

      const platformFeeAmount = (listingPrice * 250n) / 10000n; // 2.5%
      const royaltyAmount = (listingPrice * 500n) / 10000n; // 5%
      const sellerAmount = listingPrice - platformFeeAmount - royaltyAmount;

      const organizerBalanceAfter = await ethers.provider.getBalance(organizer.address);
      const sellerBalanceAfter = await ethers.provider.getBalance(seller.address);
      const feeRecipientBalanceAfter = await ethers.provider.getBalance(feeRecipient.address);

      expect(organizerBalanceAfter - organizerBalanceBefore).to.equal(royaltyAmount);
      expect(sellerBalanceAfter - sellerBalanceBefore).to.equal(sellerAmount);
      expect(feeRecipientBalanceAfter - feeRecipientBalanceBefore).to.equal(platformFeeAmount);
    });
  });

  describe('Platform Fee Management', function () {
    it('Should update platform fee correctly', async function () {
      const newFee = 500; // 5%
      
      await marketplace.connect(owner).setPlatformFee(newFee);
      expect(await marketplace.platformFee()).to.equal(newFee);
    });

    it('Should fail if fee is too high', async function () {
      const newFee = 1500; // 15% - too high
      
      await expect(
        marketplace.connect(owner).setPlatformFee(newFee)
      ).to.be.revertedWith('Fee too high');
    });

    it('Should fail if not owner', async function () {
      await expect(
        marketplace.connect(seller).setPlatformFee(500)
      ).to.be.revertedWith('Ownable: caller is not the owner');
    });
  });

  describe('View Functions', function () {
    it('Should check if token is listed correctly', async function () {
      expect(await marketplace.isTokenListed(1)).to.be.false;
      
      await eventTicket.connect(seller).approve(await marketplace.getAddress(), 1);
      await marketplace.connect(seller).listTicket(1, ethers.parseEther('0.12'));
      
      expect(await marketplace.isTokenListed(1)).to.be.true;
      
      await marketplace.connect(seller).cancelListing(1);
      expect(await marketplace.isTokenListed(1)).to.be.false;
    });
  });
});