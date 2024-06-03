// SPDX-License-Identifier: MIT
// Reference: https://wizard.openzeppelin.com/#governor

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/governance/Governor.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorCountingSimple.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorVotes.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorVotesQuorumFraction.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorTimelockControl.sol";

/**
 * @title Governance
 * @dev Implementation of a Governor contract using OpenZeppelin's Governor modules.
 * This contract uses a token-based voting mechanism and includes quorum and timelock features.
 */
contract Governance is
    Governor,
    GovernorCountingSimple,
    GovernorVotes,
    GovernorVotesQuorumFraction,
    GovernorTimelockControl
{
    uint256 public votingDelay_;
    uint256 public votingPeriod_;

    /**
     * @dev Constructor for the Governance contract.
     * @param _token The ERC20Votes token used for voting.
     * @param _timelock The TimelockController contract.
     * @param _quorum The quorum fraction for proposals.
     * @param _votingDelay The delay before voting starts, in blocks.
     * @param _votingPeriod The duration of the voting period, in blocks.
     */
    constructor(
        ERC20Votes _token,
        TimelockController _timelock,
        uint256 _quorum,
        uint256 _votingDelay,
        uint256 _votingPeriod
    )
        Governor("Omnik Decentralized Autonomous Organization")
        GovernorVotes(_token)
        GovernorVotesQuorumFraction(_quorum)
        GovernorTimelockControl(_timelock)
    {
        votingDelay_ = _votingDelay;
        votingPeriod_ = _votingPeriod;
    }

    /**
     * @dev Returns the voting delay in blocks.
     */
    function votingDelay() public view override returns (uint256) {
        return votingDelay_;
    }

    /**
     * @dev Returns the voting period in blocks.
     */
    function votingPeriod() public view override returns (uint256) {
        return votingPeriod_;
    }

    // The following functions are overrides required by Solidity.

    /**
     * @dev Returns the quorum required for a proposal to pass at a given block number.
     * @param blockNumber The block number at which to check the quorum.
     */
    function quorum(uint256 blockNumber)
        public
        view
        override(IGovernor, GovernorVotesQuorumFraction)
        returns (uint256)
    {
        return super.quorum(blockNumber);
    }

    /**
     * @dev Returns the number of votes for a given account at a given block number.
     * @param account The address of the account.
     * @param blockNumber The block number at which to get the votes.
     */
    function getVotes(address account, uint256 blockNumber)
        public
        view
        override(IGovernor, GovernorVotes)
        returns (uint256)
    {
        return super.getVotes(account, blockNumber);
    }

    /**
     * @dev Returns the state of a proposal.
     * @param proposalId The ID of the proposal.
     */
    function state(uint256 proposalId)
        public
        view
        override(Governor, GovernorTimelockControl)
        returns (ProposalState)
    {
        return super.state(proposalId);
    }

    /**
     * @dev Creates a new proposal.
     * @param targets The addresses of the contract calls to be executed.
     * @param values The values (in wei) to be passed with the contract calls.
     * @param calldatas The calldata to be passed with each contract call.
     * @param description A description of the proposal.
     */
    function propose(
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        string memory description
    ) public override(Governor, IGovernor) returns (uint256) {
        return super.propose(targets, values, calldatas, description);
    }

    /**
     * @dev Executes a proposal.
     * @param proposalId The ID of the proposal.
     * @param targets The addresses of the contract calls to be executed.
     * @param values The values (in wei) to be passed with the contract calls.
     * @param calldatas The calldata to be passed with each contract call.
     * @param descriptionHash The hash of the proposal description.
     */
    function _execute(
        uint256 proposalId,
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        bytes32 descriptionHash
    ) internal override(Governor, GovernorTimelockControl) {
        super._execute(proposalId, targets, values, calldatas, descriptionHash);
    }

    /**
     * @dev Cancels a proposal.
     * @param targets The addresses of the contract calls to be executed.
     * @param values The values (in wei) to be passed with the contract calls.
     * @param calldatas The calldata to be passed with each contract call.
     * @param descriptionHash The hash of the proposal description.
     */
    function _cancel(
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        bytes32 descriptionHash
    ) internal override(Governor, GovernorTimelockControl) returns (uint256) {
        return super._cancel(targets, values, calldatas, descriptionHash);
    }

    /**
     * @dev Returns the address of the executor.
     */
    function _executor()
        internal
        view
        override(Governor, GovernorTimelockControl)
        returns (address)
    {
        return super._executor();
    }

    /**
     * @dev Checks if the contract supports a given interface.
     * @param interfaceId The ID of the interface.
     */
    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(Governor, GovernorTimelockControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
