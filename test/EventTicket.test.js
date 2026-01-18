const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("EventTicket", function () {
  let eventTicket;
  let owner;
  let organizer;
  let buyer;

  beforeEach(async function () {
    [owner, organizer, buyer] = await ethers.getSigners();
    
    const EventTicket = await ethers.getContractFactory("EventTicket");
    eventTicket = await EventTicket.deploy();
  });

  describe("Deployment", function () {
    it("Should set the correct name and symbol", async function () {
      expect(await eventTicket.name()).to.equal("EventTicket");
      expect(await eventTicket.symbol()).to.equal("ETKT");
    });

    it("Should set the correct owner", async function () {
      expect(await eventTicket.owner()).to.equal(owner.address);
    });
  });

  describe("Event Creation", function () {
    it("Should create an event successfully", async function () {
      const eventDate = Math.floor(Date.now() / 1000) + 86400; // 1 day from now
      
      const tx = await eventTicket.connect(organizer).createEvent(
        "Test Event",
        eventDate,
        "Test Venue",
        ethers.parseEther("0.1"),
        100,
        0 // TransferRestriction.NONE
      );

      await expect(tx)
        .to.emit(eventTicket, "EventCreated")
        .withArgs(1, "Test Event", organizer.address, 100, 0);

      const event = await eventTicket.getEvent(1);
      expect(event.name).to.equal("Test Event");
      expect(event.organizer).to.equal(organizer.address);
      expect(event.isActive).to.be.true;
      expect(event.maxSupply).to.equal(100);
      expect(event.transferRestriction).to.equal(0);
    });
  });

  describe("Ticket Minting", function () {
    beforeEach(async function () {
      const eventDate = Math.floor(Date.now() / 1000) + 86400;
      await eventTicket.connect(organizer).createEvent(
        "Test Event",
        eventDate,
        "Test Venue",
        ethers.parseEther("0.1"),
        100,
        0 // TransferRestriction.NONE
      );
    });

    it("Should mint a ticket successfully", async function () {
      const tx = await eventTicket.connect(buyer).mintTicket(
        1,
        1,
        { value: ethers.parseEther("0.1") }
      );

      await expect(tx)
        .to.emit(eventTicket, "TicketMinted")
        .withArgs(1, 1, buyer.address);

      expect(await eventTicket.ownerOf(1)).to.equal(buyer.address);
      
      const ticket = await eventTicket.getTicket(1);
      expect(ticket.eventId).to.equal(1);
      expect(ticket.originalBuyer).to.equal(buyer.address);
      expect(ticket.isUsed).to.be.false;
    });

    it("Should fail with insufficient payment", async function () {
      await expect(
        eventTicket.connect(buyer).mintTicket(
          1,
          1,
          { value: ethers.parseEther("0.05") }
        )
      ).to.be.revertedWith("Insufficient payment");
    });
  });

  describe("Ticket Verification", function () {
    beforeEach(async function () {
      const eventDate = Math.floor(Date.now() / 1000) + 86400;
      await eventTicket.connect(organizer).createEvent(
        "Test Event",
        eventDate,
        "Test Venue",
        ethers.parseEther("0.1"),
        100,
        0 // TransferRestriction.NONE
      );
      
      await eventTicket.connect(buyer).mintTicket(
        1,
        1,
        { value: ethers.parseEther("0.1") }
      );
    });

    it("Should verify a ticket successfully", async function () {
      const tx = await eventTicket.verifyTicket(1);
      
      await expect(tx)
        .to.emit(eventTicket, "TicketVerified")
        .withArgs(1, owner.address);

      const ticket = await eventTicket.getTicket(1);
      expect(ticket.isUsed).to.be.true;
      expect(await eventTicket.verifiedTickets(1)).to.be.true;
    });

    it("Should fail to verify already used ticket", async function () {
      await eventTicket.verifyTicket(1);
      
      await expect(
        eventTicket.verifyTicket(1)
      ).to.be.revertedWith("Ticket already used");
    });
  });

  describe("Transfer Restrictions", function () {
    it("Should allow transfers with NONE restriction", async function () {
      const eventDate = Math.floor(Date.now() / 1000) + 86400;
      await eventTicket.connect(organizer).createEvent(
        "Test Event",
        eventDate,
        "Test Venue",
        ethers.parseEther("0.1"),
        100,
        0 // TransferRestriction.NONE
      );
      
      await eventTicket.connect(buyer).mintTicket(
        1,
        1,
        { value: ethers.parseEther("0.1") }
      );
      
      // Should allow transfer
      await eventTicket.connect(buyer).transferFrom(buyer.address, organizer.address, 1);
      expect(await eventTicket.ownerOf(1)).to.equal(organizer.address);
    });

    it("Should restrict transfers with NO_TRANSFER restriction", async function () {
      const eventDate = Math.floor(Date.now() / 1000) + 86400;
      await eventTicket.connect(organizer).createEvent(
        "Test Event",
        eventDate,
        "Test Venue",
        ethers.parseEther("0.1"),
        100,
        2 // TransferRestriction.NO_TRANSFER
      );
      
      await eventTicket.connect(buyer).mintTicket(
        1,
        1,
        { value: ethers.parseEther("0.1") }
      );
      
      // Should fail transfer
      await expect(
        eventTicket.connect(buyer).transferFrom(buyer.address, organizer.address, 1)
      ).to.be.revertedWith("Transfer not allowed");
    });
  });
});