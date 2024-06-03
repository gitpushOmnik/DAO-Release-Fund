// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";

/**
 * @title Token
 * @dev ERC20 token with voting capabilities, using OpenZeppelin's ERC20Votes extension.
 */
contract Token is ERC20Votes {
    /**
     * @dev Constructor for the Token contract.
     * @param _name The name of the token.
     * @param _symbol The symbol of the token.
     * @param _initialSupply The initial supply of tokens, in smallest units.
     */
    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _initialSupply
    ) ERC20(_name, _symbol) ERC20Permit(_name) {
        _mint(msg.sender, _initialSupply);
    }

    /**
     * @dev Hook that is called after any transfer of tokens. This includes minting and burning.
     * @param from The address from which the tokens are transferred.
     * @param to The address to which the tokens are transferred.
     * @param amount The number of tokens transferred.
     */
    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override(ERC20Votes) {
        super._afterTokenTransfer(from, to, amount);
    }

    /**
     * @dev Creates `amount` new tokens for `to`.
     * @param to The address to which the newly minted tokens are sent.
     * @param amount The number of tokens to be minted.
     */
    function _mint(address to, uint256 amount) internal override(ERC20Votes) {
        super._mint(to, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the total supply.
     * @param account The address from which the tokens are burned.
     * @param amount The number of tokens to be burned.
     */
    function _burn(address account, uint256 amount)
        internal
        override(ERC20Votes)
    {
        super._burn(account, amount);
    }
}
