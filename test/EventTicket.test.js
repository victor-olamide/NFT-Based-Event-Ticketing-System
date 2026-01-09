const { expect } = require('chai');
const { ethers } = require('hardhat');
const { time } = require('@nomicfoundation/hardhat-network-helpers');

describe('EventTicket', function () {
  let eventTicket;
  let owner;
  let organizer;
  let buyer1;
  let buyer2;
  let verifier;

  const eventData = {
    name: 'Base Music Festival 2024',
    description: 'Annual music festival featuring top artists',
    venue: 'Base Arena, San Francisco',
    totalTickets: 1000,
    ticketPrice: ethers.parseEther('0.1'),
    maxTransferPrice: ethers.parseEther('0.15'),
    transferable: true
  };

  beforeEach(async function () {
    [owner, organizer, buyer1, buyer2, verifier] = await ethers.getSigners();
    
    const EventTicket = await ethers.getContractFactory('EventTicket');
    eventTicket = await EventTicket.deploy();
    
    // Set event date to 30 days from now
    eventData.date = (await time.latest()) + (30 * 24 * 60 * 60);
  });

  describe('Deployment', function () {
    it('Should set the correct name and symbol', async function () {
      expect(await eventTicket.name()).to.equal('EventTicket');
      expect(await eventTicket.symbol()).to.equal('ETKT');
    });

    it('Should set the correct owner', async function () {
      expect(await eventTicket.owner()).to.equal(owner.address);
    });
  });

  describe('Event Creation', function () {
    it('Should create an event successfully', async function () {
      const tx = await eventTicket.connect(organizer).createEvent(
        eventData.name,
        eventData.description,
        eventData.date,
        eventData.venue,
        eventData.totalTickets,
        eventData.ticketPrice,
        eventData.maxTransferPrice,
        eventData.transferable
      );

      const receipt = await tx.wait();
      const eventCreatedEvent = receipt.logs.find(
        log => log.fragment && log.fragment.name === 'EventCreated'
      );

      expect(eventCreatedEvent.args.eventId).to.equal(1);
      expect(eventCreatedEvent.args.name).to.equal(eventData.name);
      expect(eventCreatedEvent.args.organizer).to.equal(organizer.address);

      const event = await eventTicket.events(1);
      expect(event.name).to.equal(eventData.name);
      expect(event.organizer).to.equal(organizer.address);
      expect(event.isActive).to.be.true;
    });

    it('Should increment event IDs correctly', async function () {
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

      await eventTicket.connect(organizer).createEvent(
        'Second Event',
        'Second Description',
        eventData.date,
        eventData.venue,
        eventData.totalTickets,
        eventData.ticketPrice,
        eventData.maxTransferPrice,
        eventData.transferable
      );

      const event1 = await eventTicket.events(1);
      const event2 = await eventTicket.events(2);

      expect(event1.name).to.equal(eventData.name);
      expect(event2.name).to.equal('Second Event');
    });
  });

  describe('Ticket Minting', function () {
    beforeEach(async function () {
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
    });

    it('Should mint a ticket successfully', async function () {
      const seatNumber = 1;
      const qrCode = 'QR_CODE_123';

      const tx = await eventTicket.connect(buyer1).mintTicket(
        1, // eventId
        seatNumber,
        qrCode,
        { value: eventData.ticketPrice }
      );

      const receipt = await tx.wait();
      const ticketMintedEvent = receipt.logs.find(
        log => log.fragment && log.fragment.name === 'TicketMinted'
      );

      expect(ticketMintedEvent.args.ticketId).to.equal(1);
      expect(ticketMintedEvent.args.eventId).to.equal(1);
      expect(ticketMintedEvent.args.buyer).to.equal(buyer1.address);

      const ticket = await eventTicket.tickets(1);
      expect(ticket.eventId).to.equal(1);
      expect(ticket.originalBuyer).to.equal(buyer1.address);
      expect(ticket.seatNumber).to.equal(seatNumber);
      expect(ticket.qrCode).to.equal(qrCode);
      expect(ticket.isUsed).to.be.false;

      expect(await eventTicket.ownerOf(1)).to.equal(buyer1.address);
    });

    it('Should fail if insufficient payment', async function () {
      await expect(
        eventTicket.connect(buyer1).mintTicket(
          1,
          1,
          'QR_CODE_123',
          { value: ethers.parseEther('0.05') } // Less than required
        )
      ).to.be.revertedWith('Insufficient payment');
    });

    it('Should fail if event does not exist', async function () {
      await expect(
        eventTicket.connect(buyer1).mintTicket(
          999, // Non-existent event
          1,
          'QR_CODE_123',
          { value: eventData.ticketPrice }
        )
      ).to.be.revertedWith('Event not active');
    });

    it('Should update tickets sold count', async function () {
      await eventTicket.connect(buyer1).mintTicket(
        1,
        1,
        'QR_CODE_123',
        { value: eventData.ticketPrice }
      );

      const event = await eventTicket.events(1);
      expect(event.ticketsSold).to.equal(1);
    });
  });

  describe('Ticket Verification', function () {
    beforeEach(async function () {
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

      await eventTicket.connect(buyer1).mintTicket(
        1,
        1,
        'QR_CODE_123',
        { value: eventData.ticketPrice }
      );
    });

    it('Should verify a ticket successfully', async function () {
      const tx = await eventTicket.connect(verifier).verifyTicket(1);
      const receipt = await tx.wait();

      const ticketVerifiedEvent = receipt.logs.find(
        log => log.fragment && log.fragment.name === 'TicketVerified'
      );

      expect(ticketVerifiedEvent.args.ticketId).to.equal(1);
      expect(ticketVerifiedEvent.args.verifier).to.equal(verifier.address);

      const ticket = await eventTicket.tickets(1);
      expect(ticket.isUsed).to.be.true;

      expect(await eventTicket.verifiedTickets(1)).to.be.true;
    });

    it('Should fail to verify non-existent ticket', async function () {
      await expect(
        eventTicket.connect(verifier).verifyTicket(999)
      ).to.be.revertedWith('Ticket does not exist');
    });

    it('Should fail to verify already used ticket', async function () {
      await eventTicket.connect(verifier).verifyTicket(1);
      
      await expect(
        eventTicket.connect(verifier).verifyTicket(1)
      ).to.be.revertedWith('Ticket already used');
    });
  });

  describe('Ticket Transfers', function () {
    beforeEach(async function () {
      await eventTicket.connect(organizer).createEvent(
        eventData.name,
        eventData.description,
        eventData.date,
        eventData.venue,
        eventData.totalTickets,
        eventData.ticketPrice,
        eventData.maxTransferPrice,
        true // transferable
      );

      await eventTicket.connect(buyer1).mintTicket(
        1,
        1,
        'QR_CODE_123',
        { value: eventData.ticketPrice }
      );
    });

    it('Should allow transfer of transferable tickets', async function () {
      await eventTicket.connect(buyer1).transferFrom(
        buyer1.address,
        buyer2.address,
        1
      );

      expect(await eventTicket.ownerOf(1)).to.equal(buyer2.address);
    });

    it('Should prevent transfer of non-transferable tickets', async function () {
      // Create non-transferable event
      await eventTicket.connect(organizer).createEvent(
        'Non-transferable Event',
        'Description',
        eventData.date,
        eventData.venue,
        eventData.totalTickets,
        eventData.ticketPrice,
        eventData.maxTransferPrice,
        false // not transferable
      );

      await eventTicket.connect(buyer1).mintTicket(
        2, // second event
        1,
        'QR_CODE_456',
        { value: eventData.ticketPrice }
      );

      await expect(
        eventTicket.connect(buyer1).transferFrom(
          buyer1.address,
          buyer2.address,
          2
        )
      ).to.be.revertedWith('Ticket not transferable');
    });
  });

  describe('Edge Cases', function () {
    it('Should handle sold out events', async function () {
      await eventTicket.connect(organizer).createEvent(
        eventData.name,
        eventData.description,
        eventData.date,
        eventData.venue,
        1, // Only 1 ticket
        eventData.ticketPrice,
        eventData.maxTransferPrice,
        eventData.transferable
      );

      // Buy the only ticket
      await eventTicket.connect(buyer1).mintTicket(
        1,
        1,
        'QR_CODE_123',
        { value: eventData.ticketPrice }
      );

      // Try to buy another ticket
      await expect(
        eventTicket.connect(buyer2).mintTicket(
          1,
          2,
          'QR_CODE_456',
          { value: eventData.ticketPrice }
        )
      ).to.be.revertedWith('Sold out');
    });

    it('Should handle overpayment correctly', async function () {
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

      const overpayment = ethers.parseEther('0.2'); // More than required
      const initialBalance = await ethers.provider.getBalance(buyer1.address);

      const tx = await eventTicket.connect(buyer1).mintTicket(
        1,
        1,
        'QR_CODE_123',
        { value: overpayment }
      );

      const receipt = await tx.wait();
      const gasUsed = receipt.gasUsed * receipt.gasPrice;
      const finalBalance = await ethers.provider.getBalance(buyer1.address);

      // Should only charge the ticket price, not the overpayment
      const expectedBalance = initialBalance - eventData.ticketPrice - gasUsed;
      expect(finalBalance).to.be.closeTo(expectedBalance, ethers.parseEther('0.001'));
    });
  });
});