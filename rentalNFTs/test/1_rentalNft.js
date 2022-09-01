const { ethers } = require("hardhat");
const { assert, expect } = require("chai");

describe("Rental Nft contract", () => {
  let owner;
  let borrower;

  const Name = "Sky";
  const Symbol = "Blue";

  let Rentalnft;

  beforeEach(async () => {
    [owner, borrower] = await ethers.getSigners();
    const rentalnft = await ethers.getContractFactory("erc4907");
    Rentalnft = await rentalnft.deploy(Name, Symbol);
    await Rentalnft.deployed();
  });

  describe("Deployment", () => {
    it("Should give the name correct", async () => {
      expect(await Rentalnft.name()).to.equal(Name);
    });

    it("Should give the correct symbol", async () => {
      expect(await Rentalnft.symbol()).to.equal(Symbol);
    });
  });

  describe("Minting Nfts", () => {
    // const instance = Rentalnft;
    it("The user should be borrower and the owner should be owner!", async () => {
      await Rentalnft.mint(1, owner.address);
      let expires = Math.floor(new Date().getTime() / 1000) + 5;
      await Rentalnft.setUser(1, borrower.address, BigInt(expires));
      let user_1 = await Rentalnft.userOf(1);
      assert.equal(borrower.address, user_1, "The user should be user");
      let owner_1 = await Rentalnft.ownerOf(1);
      assert.equal(owner.address, owner_1, "The owner should be owner");
    });
  });
});
