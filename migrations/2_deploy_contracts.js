const Token = artifacts.require("Token");
const Timelock = artifacts.require("Timelock");
const Governance = artifacts.require("Governance");
const Treasury = artifacts.require("Treasury");

module.exports = async function (deployer) {
    // Get accounts to be used in the deployment process
    const [executor, proposer, voter1, voter2, voter3, voter4, voter5] = await web3.eth.getAccounts();

    // Token details
    const name = "Omnik DAO";
    const symbol = "OMNIK";
    const supply = web3.utils.toWei('10000', 'ether'); // Initial supply of 10,000 tokens

    // Deploy the Token contract
    await deployer.deploy(Token, name, symbol, supply);
    const token = await Token.deployed();

    // Distribute tokens to voters
    const amount = web3.utils.toWei('50', 'ether'); // Each voter receives 50 tokens
    await token.transfer(voter1, amount, { from: executor });
    await token.transfer(voter2, amount, { from: executor });
    await token.transfer(voter3, amount, { from: executor });
    await token.transfer(voter4, amount, { from: executor });
    await token.transfer(voter5, amount, { from: executor });

    // Timelock parameters
    const _timeDelay = 1; // Minimum delay before execution (in seconds)

    // Deploy the Timelock contract
    await deployer.deploy(Timelock, _timeDelay, [proposer], [executor]);
    const timelock = await Timelock.deployed();

    // Governance parameters
    const quorum = 5; // Percentage of votes needed for quorum
    const votingDelay = 0; // Delay before voting starts (in blocks)
    const votingPeriod = 5; // Duration of the voting period (in blocks)

    // Deploy the Governance contract
    await deployer.deploy(Governance, token.address, timelock.address, quorum, votingDelay, votingPeriod);
    const governance = await Governance.deployed();

    // Treasury parameters
    const funds = web3.utils.toWei('25', 'ether'); // Initial funds for the treasury

    // Deploy the Treasury contract
    await deployer.deploy(Treasury, executor, { value: funds });
    const treasury = await Treasury.deployed();

    // Transfer ownership of the Treasury to the Timelock contract
    await treasury.transferOwnership(timelock.address, { from: executor });

    // Assign roles in the Timelock contract
    const proposerRole = await timelock.PROPOSER_ROLE();
    const executorRole = await timelock.EXECUTOR_ROLE();

    // Grant roles to the Governance contract
    await timelock.grantRole(proposerRole, governance.address, { from: executor });
    await timelock.grantRole(executorRole, governance.address, { from: executor });
};
