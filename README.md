# Decentralized Governance DAO

This project implements a decentralized autonomous organization (DAO) on the Ethereum blockchain. The DAO allows its token holders to participate in the governance process by creating, voting on, and executing proposals. This enables the community to make collective decisions and manage the DAO's resources in a transparent and decentralized manner.

The DAO leverages the OpenZeppelin library and consists of four main contracts: `Token`, `TimeLock`, `Treasury`, and `Governance`. The `Token` contract represents the DAO's native ERC20 token with voting capabilities, enabling token holders to vote on proposals. The `TimeLock` contract ensures that approved proposals go through a predetermined time delay before execution, allowing the community to review and potentially cancel undesirable proposals. The `Treasury` contract manages the DAO's funds and their release, with the ownership transferred to the `TimeLock` contract for governance oversight. The `Governance` contract orchestrates the entire governance process, facilitating proposal creation, voting, and execution through the `TimeLock` contract.

## Contracts

### Token

The `Token` contract is an ERC20 token with voting capabilities, using the `ERC20Votes` extension from OpenZeppelin. It allows token holders to vote on proposals and participate in the DAO's governance process.

### TimeLock

The `TimeLock` contract is a `TimelockController` from OpenZeppelin. It manages the delayed execution of proposals, ensuring that changes to the DAO's state go through a predetermined timelock period before being executed. This ensures that the community has sufficient time to review and potentially cancel undesirable proposals.

### Treasury

The `Treasury` contract manages the DAO's funds and their release. It allows the DAO owner to release the funds to a designated payee after certain conditions are met. The ownership of the `Treasury` contract is transferred to the `TimeLock` contract during deployment, ensuring that the release of funds is governed by the DAO's governance process.

### Governance

The `Governance` contract is the core of the DAO's governance system. It leverages the `Token`, `TimeLock`, and other OpenZeppelin contracts to enable the creation and voting of proposals, as well as the execution of approved proposals through the `TimeLock` contract.

## Deployment

The project includes a deployment script (`migrations/2_deploy_contracts.js`) that handles the deployment of the contracts and the initial setup of the DAO. The script performs the following steps:

1. Deploys the `Token` contract with the specified name, symbol, and initial supply.
2. Distributes a portion of the initial token supply to a set of voter addresses.
3. Deploys the `TimeLock` contract with a specified minimum delay and authorized proposers and executors.
4. Deploys the `Governance` contract, connecting it to the `Token` and `TimeLock` contracts, and configuring the voting parameters (quorum, voting delay, and voting period).
5. Deploys the `Treasury` contract with an initial fund amount and a designated payee.
6. Transfers the ownership of the `Treasury` contract to the `TimeLock` contract.
7. Grants the `PROPOSER_ROLE` and `EXECUTOR_ROLE` to the `Governance` contract in the `TimeLock` contract.

To deploy the contracts, you'll need to have a local Ethereum development environment set up (e.g., Ganache) and the appropriate dependencies installed. Then, you can run the deployment script using a tool like Truffle.

## Usage

After deploying the contracts, you can interact with the DAO through the `Governance` contract. Token holders can create proposals, vote on proposals, and execute approved proposals through the governance process managed by the `Governance` contract.

The `Treasury` contract allows the DAO owner to release the funds to the designated payee after the governance process approves the release.

For more detailed information on using the DAO and its contracts, please refer to the Solidity code and the OpenZeppelin documentation.

## Deployment

1. **Deploy Smart Contracts to Ganache**:

   > truffle migrate

2. **Running Deployment Script for initiating funds release**:

   > truffle exec scripts/issue-token.js

## License

This project is licensed under the [MIT License](LICENSE).