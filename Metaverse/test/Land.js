const { expect } = require("chai");
const { ethers } = require("hardhat");

const EVM_REVERT = "VM Exception while processing transaction: revert";

describe("V-world metaWorld", () => {
  let owner1;
  let owner2;
  let addrs;

  const NAME = "V-world";
  const SYMBOL = "meta";
  const COST = ethers.utils.formatUnits(1, "wei");

  let metaWorld;
  let result;

  beforeEach(async () => {
    meta = await ethers.getContractFactory("Vworld");
    [owner1, owner2, ...addrs] = await ethers.getSigners();
    metaWorld = await meta.deploy(NAME, SYMBOL, COST);
  });

  describe("Deployment", () => {
    it("returns the contract name", async () => {
      expect(await metaWorld.name()).to.equal(NAME);
    });
    it("returns the contract symbol", async () => {
      expect(await metaWorld.symbol()).to.equal(SYMBOL);
    });
    it("returns the cost of the mint", async () => {
      expect(await metaWorld.cost()).to.equal(COST);
    });
    it("returns the maximum number of metaWorlds", async () => {
      expect(await metaWorld.maxSupply()).to.equal(3);
    });
    it("returns the sold metaWorlds are zero!", async () => {
      expect(await metaWorld.totalSupply()).to.equal(0);
    });
  });

  describe("Minting", () => {
    describe("Success", () => {
      beforeEach(async () => {
        await metaWorld.mint(1, { from: owner1, value: COST });
      });

      it("Updates the owner address", async () => {
        expect(await metaWorld.ownerOf(1)).should.equal(owner1);
      });

      it("Updates area details", async () => {
        result = await metaWorld.getArea(1);
        result.owner.should.equal(owner1);
      });
    });

    describe("Failure", () => {
      it("Prevents mint with 0 value", async () => {
        await metaWorld
          .mint(1, { from: owner1, value: 0 })
          .should.be.rejectedWith(EVM_REVERT);
      });

      it("Prevents mint with invalid ID", async () => {
        await metaWorld
          .mint(100, { from: owner1, value: 1 })
          .should.be.rejectedWith(EVM_REVERT);
      });

      it("Prevents minting if already owned", async () => {
        await metaWorld.mint(1, { from: owner1, value: COST });
        await metaWorld
          .mint(1, { from: owner2, value: COST })
          .should.be.rejectedWith(EVM_REVERT);
      });
    });
  });

  describe("Transfers", () => {
    describe("success", () => {
      beforeEach(async () => {
        await metaWorld.mint(1, { from: owner1, value: COST });
        await metaWorld.approve(owner2, 1, { from: owner1 });
        await metaWorld.transferFrom(owner1, owner2, 1, { from: owner2 });
      });

      it("Updates the owner address", async () => {
        result = await metaWorld.ownerOf(1);
        result.should.equal(owner2);
      });

      it("Updates area details", async () => {
        result = await metaWorld.Area(1);
        result.owner.should.equal(owner2);
      });
    });

    describe("failure", () => {
      it("Prevents transfers without ownership", async () => {
        await metaWorld
          .transferFrom(owner1, owner2, 1, { from: owner2 })
          .should.be.rejectedWith(EVM_REVERT);
      });

      it("Prevents transfers without approval", async () => {
        await metaWorld.mint(1, { from: owner1, value: COST });
        await metaWorld
          .transferFrom(owner1, owner2, 1, { from: owner2 })
          .should.be.rejectedWith(EVM_REVERT);
      });
    });
  });
});
