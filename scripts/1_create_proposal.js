const Token = artifacts.require("Token");
const Timelock = artifacts.require("Timelock");
const Governance = artifacts.require("Governance");
const Treasury = artifacts.require("Treasury");

module.exports = async function (callback) {
    // Retrieve the list of accounts
    const [executor, proposer, voter1, voter2, voter3, voter4, voter5] = await web3.eth.getAccounts();

    let isReleased, funds, blockNumber, proposalState, vote;

    const amount = web3.utils.toWei('5', 'ether');

    // Retrieve the deployed Token contract
    const token = await Token.deployed();

    // Delegate voting power to voters
    await token.delegate(voter1, { from: voter1 });
    await token.delegate(voter2, { from: voter2 });
    await token.delegate(voter3, { from: voter3 });
    await token.delegate(voter4, { from: voter4 });
    await token.delegate(voter5, { from: voter5 });

    // Retrieve the deployed Treasury contract
    const treasury = await Treasury.deployed();

    // Check if the funds have been released
    isReleased = await treasury.isReleased();
    console.log(`Funds released? ${isReleased}`);

    // Get the balance of the treasury contract
    funds = await web3.eth.getBalance(treasury.address);
    console.log(`Funds inside of treasury: ${web3.utils.fromWei(funds.toString(), 'ether')} ETH\n`);

    // Retrieve the deployed Governance contract
    const governance = await Governance.deployed();

    // Encode the function to release funds from the treasury
    const encodedFunction = await treasury.contract.methods.releaseFunds().encodeABI();
    const description = "Release Funds from Treasury";

    // Propose a new governance proposal
    const tx = await governance.propose([treasury.address], [0], [encodedFunction], description, { from: proposer });

    // Get the proposal ID from the transaction logs
    const id = tx.logs[0].args.proposalId;
    console.log(`Created Proposal: ${id.toString()}\n`);

    // Check the current state of the proposal (Pending)
    proposalState = await governance.state.call(id);
    console.log(`Current state of proposal: ${proposalState.toString()} (Pending) \n`);

    // Get the block number when the proposal was created
    const snapshot = await governance.proposalSnapshot.call(id);
    console.log(`Proposal created on block ${snapshot.toString()}`);

    // Get the proposal deadline block number
    const deadline = await governance.proposalDeadline.call(id);
    console.log(`Proposal deadline on block ${deadline.toString()}\n`);

    // Get the current block number
    blockNumber = await web3.eth.getBlockNumber();
    console.log(`Current block number: ${blockNumber}\n`);

    // Get the number of votes required to reach quorum
    const quorum = await governance.quorum(blockNumber - 1);
    console.log(`Number of votes required to pass: ${web3.utils.fromWei(quorum.toString(), 'ether')}\n`);

    console.log(`Casting votes...\n`);

    // Cast votes (0 = Against, 1 = For, 2 = Abstain)
    await governance.castVote(id, 1, { from: voter1 });
    await governance.castVote(id, 1, { from: voter2 });
    await governance.castVote(id, 1, { from: voter3 });
    await governance.castVote(id, 0, { from: voter4 });
    await governance.castVote(id, 2, { from: voter5 });

    // Check the current state of the proposal (Active)
    proposalState = await governance.state.call(id);
    console.log(`Current state of proposal: ${proposalState.toString()} (Active) \n`);

    // Transfer tokens to the proposer
    await token.transfer(proposer, amount, { from: executor });

    // Get the number of votes for, against, and abstain
    const { againstVotes, forVotes, abstainVotes } = await governance.proposalVotes.call(id);
    console.log(`Votes For: ${web3.utils.fromWei(forVotes.toString(), 'ether')}`);
    console.log(`Votes Against: ${web3.utils.fromWei(againstVotes.toString(), 'ether')}`);
    console.log(`Votes Neutral: ${web3.utils.fromWei(abstainVotes.toString(), 'ether')}\n`);

    // Get the current block number
    blockNumber = await web3.eth.getBlockNumber();
    console.log(`Current block number: ${blockNumber}\n`);

    // Check the current state of the proposal (Succeeded)
    proposalState = await governance.state.call(id);
    console.log(`Current state of proposal: ${proposalState.toString()} (Succeeded) \n`);

    // Queue the proposal for execution
    const hash = web3.utils.sha3("Release Funds from Treasury");
    await governance.queue([treasury.address], [0], [encodedFunction], hash, { from: executor });

    // Check the current state of the proposal (Queued)
    proposalState = await governance.state.call(id);
    console.log(`Current state of proposal: ${proposalState.toString()} (Queued) \n`);

    // Execute the proposal
    await governance.execute([treasury.address], [0], [encodedFunction], hash, { from: executor });

    // Check the current state of the proposal (Executed)
    proposalState = await governance.state.call(id);
    console.log(`Current state of proposal: ${proposalState.toString()} (Executed) \n`);

    // Check if the funds have been released
    isReleased = await treasury.isReleased();
    console.log(`Funds released? ${isReleased}`);

    // Get the balance of the treasury contract after execution
    funds = await web3.eth.getBalance(treasury.address);
    console.log(`Funds inside of treasury: ${web3.utils.fromWei(funds.toString(), 'ether')} ETH\n`);

    callback();
};
