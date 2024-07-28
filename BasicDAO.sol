// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract BasicDAO {
    struct Proposal {
        uint id;
        string description;
        uint deadline;
        uint yesVotes;
        uint noVotes;
        bool executed;
        mapping(address => bool) voted;
    }

    mapping(uint => Proposal) public proposals;
    mapping(address => bool) public members;
    uint public proposalCount;
    uint public membershipFee;
    uint public votingDuration;

    address public owner;

    constructor(uint _membershipFee, uint _votingDuration) {
        owner = msg.sender;
        membershipFee = _membershipFee;
        votingDuration = _votingDuration;
    }

    modifier onlyMember() {
        require(members[msg.sender], "Only members can call this function");
        _;
    }

    function join() external payable {
        require(msg.value == membershipFee, "Incorrect membership fee");
        members[msg.sender] = true;
    }

   function createProposal(string memory _description) external onlyMember {
    proposalCount++;
    Proposal storage proposal = proposals[proposalCount];
    proposal.id = proposalCount;
    proposal.description = _description;
    proposal.deadline = block.timestamp + votingDuration;
    proposal.yesVotes = 0;
    proposal.noVotes = 0;
    proposal.executed = false;
}


    function vote(uint _proposalId, bool _vote) external onlyMember {
        Proposal storage proposal = proposals[_proposalId];
        require(block.timestamp < proposal.deadline, "Voting period has ended");
        require(!proposal.voted[msg.sender], "You have already voted");

        proposal.voted[msg.sender] = true;
        if (_vote) {
            proposal.yesVotes++;
        } else {
            proposal.noVotes++;
        }
    }

    function executeProposal(uint _proposalId) external onlyMember {
        Proposal storage proposal = proposals[_proposalId];
        require(block.timestamp >= proposal.deadline, "Voting period has not ended");
        require(!proposal.executed, "Proposal has already been executed");

        proposal.executed = true;
        if (proposal.yesVotes > proposal.noVotes) {
            // Implement the logic for proposal execution
        }
    }

    function getProposal(uint _proposalId) external view returns (
        uint id,
        string memory description,
        uint deadline,
        uint yesVotes,
        uint noVotes,
        bool executed
    ) {
        Proposal storage proposal = proposals[_proposalId];
        return (
            proposal.id,
            proposal.description,
            proposal.deadline,
            proposal.yesVotes,
            proposal.noVotes,
            proposal.executed
        );
    }
}
