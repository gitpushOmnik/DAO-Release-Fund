// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

/**
 * @title Migrations
 * @dev This contract is used to manage the deployment of other contracts. It keeps track of the last completed migration.
 */
contract Migrations {
  address public owner = msg.sender;
  uint public last_completed_migration;

  /**
   * @dev Modifier to restrict access to the owner of the contract.
   */
  modifier restricted() {
    require(
      msg.sender == owner,
      "This function is restricted to the contract's owner"
    );
    _;
  }

  /**
   * @dev Sets the last completed migration.
   * @param completed The index of the last completed migration.
   */
  function setCompleted(uint completed) public restricted {
    last_completed_migration = completed;
  }
}
