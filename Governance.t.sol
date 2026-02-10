// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "./Governance.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockToken is ERC20 {
    constructor() ERC20("GovToken", "GTK") {
        _mint(msg.sender, 10000e18);
    }
}

contract GovernanceTest is Test {
    Governance public gov;
    MockToken public token;
    address public voter = address(1);

    function setUp() public {
        token = new MockToken();
        gov = new Governance(address(token));
        token.transfer(voter, 2000e18);
    }

    function testProposalAndVote() public {
        uint256 pId = gov.propose(address(0), "");
        
        vm.roll(block.number + 2); // Move past delay
        
        vm.prank(voter);
        gov.castVote(pId, true);
        
        (, , , , uint256 forVotes, , ) = gov.proposals(pId);
        assertEq(forVotes, 2000e18);
    }
}
