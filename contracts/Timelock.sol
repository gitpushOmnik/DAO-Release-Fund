// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/governance/TimelockController.sol";

/**
 * @title TimeLock
 * @dev A TimelockController contract to manage delayed execution of proposals.
 * This contract inherits from OpenZeppelin's TimelockController.
 */
contract TimeLock is TimelockController {
    /**
     * @dev Constructor for the TimeLock contract.
     * @param _timeDelay The minimum delay for execution of proposals.
     * @param _contractProposers The list of addresses that can propose actions.
     * @param _contractExecutors The list of addresses that can execute actions.
     */
    constructor(
        uint256 _timeDelay,
        address[] memory _contractProposers,
        address[] memory _contractExecutors
    ) TimelockController(_timeDelay, _contractProposers, _contractExecutors) {}
}
