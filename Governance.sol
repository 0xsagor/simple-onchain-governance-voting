// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title Governance
 * @dev A simplified on-chain voting mechanism for token holders.
 */
contract Governance is Ownable {
    IERC20 public votingToken;
    uint256 public votingDelay = 1; // blocks
    uint256 public votingPeriod = 10; // blocks
    uint256 public quorum = 1000e18; // minimum tokens required

    enum ProposalStatus { Active, Defeated, Succeeded, Executed }

    struct Proposal {
        address target;
        bytes data;
        uint256 startBlock;
        uint256 endBlock;
        uint256 forVotes;
        uint256 againstVotes;
        bool executed;
    }

    Proposal[] public proposals;
    mapping(uint256 => mapping(address => bool)) public hasVoted;

    constructor(address _token) Ownable(msg.sender) {
        votingToken = IERC20(_token);
    }

    function propose(address target, bytes calldata data) external returns (uint256) {
        uint256 proposalId = proposals.length;
        proposals.push(Proposal({
            target: target,
            data: data,
            startBlock: block.number + votingDelay,
            endBlock: block.number + votingDelay + votingPeriod,
            forVotes: 0,
            againstVotes: 0,
            executed: false
        }));
        return proposalId;
    }

    function castVote(uint256 proposalId, bool support) external {
        Proposal storage p = proposals[proposalId];
        require(block.number >= p.startBlock && block.number <= p.endBlock, "Voting not active");
        require(!hasVoted[proposalId][msg.sender], "Already voted");

        uint256 weight = votingToken.balanceOf(msg.sender);
        require(weight > 0, "No voting power");

        if (support) p.forVotes += weight;
        else p.againstVotes += weight;

        hasVoted[proposalId][msg.sender] = true;
    }

    function execute(uint256 proposalId) external {
        Proposal storage p = proposals[proposalId];
        require(block.number > p.endBlock, "Voting still active");
        require(!p.executed, "Already executed");
        require(p.forVotes > p.againstVotes, "Proposal failed");
        require(p.forVotes + p.againstVotes >= quorum, "Quorum not met");

        p.executed = true;
        (bool success, ) = p.target.call(p.data);
        require(success, "Execution failed");
    }
}
