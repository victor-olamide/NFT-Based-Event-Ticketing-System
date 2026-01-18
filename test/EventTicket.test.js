const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("EventTicket - mintTicket Payment Processing", function () {
  let eventTicket;
  let owner;
  let organizer;
  let buyer1;
  let buyer2;

  beforeEach(async function () {
    [owner, organizer, buyer1, buyer2] = await ethers.getSigners();
    
    const EventTicket = await ethers.getContractFactory("EventTicket");
    eventTicket = await EventTicket.deploy();
  });

  describe("Ticket Minting with Payment", function () {
    beforeEach(async function () {
      const eventDate = Math.floor(Date.now() / 1000) + 86400;
      await eventTicket.connect(organizer).createEvent(
        "Test Event",
        eventDate,
        "Test Venue",
        ethers.parseEther("0.1"),
        100
      );
    });

    it("Should mint ticket with exact payment", async function () {
      const tx = await eventTicket.connect(buyer1).mintTicket(
        1,
        1,
        { value: ethers.parseEther("0.1") }
      );

      await expect(tx)
        .to.emit(eventTicket, "TicketMinted")
        .withArgs(1, 1, buyer1.address, ethers.parseEther("0.1"));

      await expect(tx)
        .to.emit(eventTicket, "PaymentReceived")
        .withArgs(buyer1.address, ethers.parseEther("0.1"), 1);

      expect(await eventTicket.ownerOf(1)).to.equal(buyer1.address);
      expect(await eventTicket.getTicketCount(buyer1.address)).to.equal(1);
    });

    it("Should refund excess payment", async function () {
      const tx = await eventTicket.connect(buyer1).mintTicket(
        1,
        1,
        { value: ethers.parseEther("0.15") }
      );

      await expect(tx)
        .to.emit(eventTicket, "RefundIssued")
        .withArgs(buyer1.address, ethers.parseEther("0.05"));
    });

    it("Should fail with insufficient payment", async function () {
      await expect(
        eventTicket.connect(buyer1).mintTicket(
          1,
          1,
          { value: ethers.parseEther("0.05") }
        )
      ).to.be.revertedWith("Insufficient payment");
    });

    it("Should enforce ticket limits per address", async function () {
      // Mint maximum tickets
      for (let i = 1; i <= 10; i++) {
        await eventTicket.connect(buyer1).mintTicket(
          1,
          i,
          { value: ethers.parseEther("0.1") }
        );
      }

      // Should fail on 11th ticket
      await expect(
        eventTicket.connect(buyer1).mintTicket(
          1,
          11,
          { value: ethers.parseEther("0.1") }
        )
      ).to.be.revertedWith("Ticket limit exceeded");
    });
  });

  describe("Batch Minting", function () {
    beforeEach(async function () {
      const eventDate = Math.floor(Date.now() / 1000) + 86400;
      await eventTicket.connect(organizer).createEvent(
        "Test Event",
        eventDate,
        "Test Venue",
        ethers.parseEther("0.1"),
        100
      );
    });

    it("Should mint multiple tickets in batch", async function () {
      const seatNumbers = [1, 2, 3];
      const totalCost = ethers.parseEther("0.3");

      const tx = await eventTicket.connect(buyer1).mintTicketsBatch(
        1,
        seatNumbers,
        { value: totalCost }
      );

      await expect(tx)
        .to.emit(eventTicket, "PaymentReceived")
        .withArgs(buyer1.address, totalCost, 1);

      expect(await eventTicket.getTicketCount(buyer1.address)).to.equal(3);
    });
  });
});