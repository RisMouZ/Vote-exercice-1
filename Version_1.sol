// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.14;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Voting is Ownable {

    uint winningProposalId;

    struct Voter {
        bool isRegistered;
        bool hasVoted;
        uint votedProposalId;
    }

    struct Proposal {
        string description;
        uint voteCount;
    }

    struct Adresse {
        address adresse;
    }

    enum WorkflowStatus {
        RegisteringVoters,
        ProposalsRegistrationStarted,
        ProposalsRegistrationEnded,
        VotingSessionStarted,
        VotingSessionEnded,
        VotesTallied
    }
    WorkflowStatus public statut;

    event VoterRegistered(address voterAddress); 
    event WorkflowStatusChange(WorkflowStatus previousStatus, WorkflowStatus newStatus);
    event ProposalRegistered(uint proposalId);
    event Voted (address voter, uint proposalId);

    mapping (address => Voter) public votersMapping;
    Adresse[] adresseArray;
    Proposal[] proposalsArray;

    // Ce constructor a pour but de créer, dès le déploiement et par l'émetteur, une proposition 
    // de _description "Blank Vote" afin de prendre le vote blanc en compte

    constructor(string memory _description) {
        proposalsArray.push(Proposal(_description, 0));
    }

    function addVoter(address _addr) public onlyOwner {
        require(statut == WorkflowStatus.RegisteringVoters, "Vous ne pouvez pas faire ca");
        votersMapping[_addr]= Voter(true, false, 0);
        adresseArray.push(Adresse(_addr));
        emit VoterRegistered(_addr);
    }

    function addProposal(string memory _description) external{
        require(statut == WorkflowStatus.ProposalsRegistrationStarted && votersMapping[msg.sender].isRegistered == true, "Vous ne pouvez pas faire ca");
        proposalsArray.push(Proposal(_description, 0));
        emit ProposalRegistered(proposalsArray.length - 1);
    }

    function vote(uint _id) external {
        require(statut == WorkflowStatus.VotingSessionStarted && votersMapping[msg.sender].hasVoted == false && votersMapping[msg.sender].isRegistered == true && _id<proposalsArray.length, "Vous ne pouvez pas faire ca");
        votersMapping[msg.sender] = Voter(true, true, _id);
        proposalsArray[_id].voteCount ++;
        emit Voted(msg.sender, _id);
    } 

    function whoWin() public onlyOwner {
        require(statut == WorkflowStatus.VotingSessionEnded);
        uint highestVotesProposal = 0;
        for(uint i=0; i<proposalsArray.length; i++) {
            if(proposalsArray[i].voteCount > highestVotesProposal) {
                highestVotesProposal = proposalsArray[i].voteCount;
                winningProposalId = i;
            }
        }
    }

    function resetVote(string memory _description) public onlyOwner {
        require(statut == WorkflowStatus.VotesTallied && winningProposalId == 0, "Vous ne pouvez pas faire ca");
        statut = WorkflowStatus(0);
        delete proposalsArray;
        proposalsArray.push(Proposal(_description, 0));
        for(uint i=0; i<adresseArray.length; i++) {
           votersMapping[adresseArray[i].adresse] = Voter(true, false, 0);
        }
        emit WorkflowStatusChange(WorkflowStatus(5), WorkflowStatus(0));
    }

    function setWorkflowStatus(WorkflowStatus _num) public onlyOwner {
        require(uint(_num) < 6, "Ce statut n'existe pas");
        statut = _num;
        emit WorkflowStatusChange(WorkflowStatus(uint(_num)-1), WorkflowStatus(uint (_num)));
    }

    function getProposalsArray() public view returns(Proposal[] memory) {
        return proposalsArray;
    }

    function getAdresseArray() public view returns(Adresse[] memory) {
        return adresseArray;
    }

    function getWinner() public view returns(uint) {
        require(statut == WorkflowStatus.VotesTallied, "Vous ne pouvez pas faire ca");
        return winningProposalId;
    }

}
