// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title Treasury
 * @dev Contract to manage the treasury funds, with release functionality controlled by the owner.
 */
contract Treasury is Ownable {
    uint256 public totalFunds;
    address public payee;
    bool public isReleased;

    /**
     * @dev Sets the payee and initializes the contract with initial funds.
     * @param _payee The address to which the funds will be released.
     */
    constructor(address _payee) payable {
        totalFunds = msg.value;
        payee = _payee;
        isReleased = false;
    }

    /**
     * @dev Releases the funds to the payee. Can only be called by the owner.
     * Sets the `isReleased` flag to true and transfers the `totalFunds` to the `payee`.
     */
    function releaseFunds() public onlyOwner {
        isReleased = true;
        payable(payee).transfer(totalFunds);
    }
}
