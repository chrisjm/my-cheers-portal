const main = async () => {
  const [owner, randomPerson] = await hre.ethers.getSigners();
  const contractFactory = await hre.ethers.getContractFactory("CheersPortal");
  const contract = await contractFactory.deploy({
    value: hre.ethers.utils.parseEther("0.1"),
  });
  await contract.deployed();

  console.log("Contract deployed to:", contract.address);
  console.log("Contract deployed by:", owner.address);

  let contractBalance = await hre.ethers.provider.getBalance(contract.address);
  console.log(
    "Contract balance:",
    hre.ethers.utils.formatEther(contractBalance)
  );

  let cheersCount;
  cheersCount = await contract.getTotalCheers();
  console.log("Total Cheers: ", cheersCount.toNumber());

  let cheersTxn = await contract.cheers("Prost!");
  await cheersTxn.wait();

  cheersCount = await contract.getTotalCheers();

  contractBalance = await hre.ethers.provider.getBalance(contract.address);
  console.log(
    "Contract balance:",
    hre.ethers.utils.formatEther(contractBalance)
  );

  cheersTxn = await contract.connect(randomPerson).cheers("Salud!");
  await cheersTxn.wait();

  cheersCount = await contract.getTotalCheers();
  console.log("Total Cheers: ", cheersCount.toNumber());

  contractBalance = await hre.ethers.provider.getBalance(contract.address);
  console.log(
    "Contract balance:",
    hre.ethers.utils.formatEther(contractBalance)
  );

  try {
    console.log("Expected cooldown...");
    cheersTxn = await contract.cheers("Cin cin!");
    await cheersTxn.wait();
  } catch (error) {
    console.log(error);
  }

  const allCheers = await contract.getAllCheers();
  console.log(allCheers);
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();
