# Simple On-Chain Governance

This repository contains a clean, professional implementation of a decentralized governance system. It allows a community of token holders to manage a protocol or treasury autonomously.

## Governance Workflow
1. **Proposal:** A token holder submits a proposal (e.g., a call to a specific contract function).
2. **Voting:** Eligible members cast their votes (Yes/No) within a specific timeframe.
3. **Execution:** If the proposal passes, anyone can trigger the execution of the proposed action.

## Key Features
- **Weight-Based Voting:** Voting power is proportional to the number of governance tokens held.
- **Quorum Requirement:** Proposals only pass if a minimum threshold of participation is met.
- **Timelock Ready:** Designed to be easily integrated with a Timelock for security delays.

## Tech Stack
- **Solidity ^0.8.20**
- **ERC-20 Governance Tokens**
- **Foundry** (Development & Testing)
