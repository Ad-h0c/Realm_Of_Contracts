const { ethers } = require("hardhat");
const main = async () => {
  let addr1;
  [addr1] = await ethers.getSigners();
  console.log(`the deployer address is: ${addr1.address}`);
  console.log(
    `the balance of the deployer is: ${(await addr1.getBalance()).toString()}`
  );
  const rentalnft = await ethers.getContractFactory("erc4907");
  const Rentalnft = await rentalnft.deploy("Sky", "Blue");
  await Rentalnft.deployed();
  console.log(`Address of the contract is: ${Rentalnft.address}`);
  console.log(
    `the balance of the deployer after the deployment is: ${(
      await addr1.getBalance()
    ).toString()}`
  );
};

main()
  .then(() => {
    process.exit(0);
  })
  .catch((err) => {
    console.log(err);
    process.exit(1);
  });
