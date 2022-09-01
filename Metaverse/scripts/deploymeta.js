const hre = require("hardhat");

async function main() {
  const NAME = "V-world";
  const SYMBOL = "meta";
  const COST = ethers.utils.formatUnits(1, "wei");
  meta = await ethers.getContractFactory("Vworld");
  metaWorld = await meta.deploy(NAME, SYMBOL, COST);

  await metaWorld.deployed();
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
