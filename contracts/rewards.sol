// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract TeacherRewards {
    // Address of the ERC20 token contract used for rewards
    IERC20 public rewardToken;

    // Admin address (contract deployer)
    address public admin;

    // Mapping from teacher address to their performance score
    mapping(address => uint256) public performanceScores;

    // Mapping from teacher address to reward balance
    mapping(address => uint256) public rewardBalances;

    // Events to log rewards issuance
    event RewardIssued(address indexed teacher, uint256 amount);

    // Constructor to initialize the contract with the token address
    constructor(address _tokenAddress) {
        rewardToken = IERC20(_tokenAddress);
        admin = msg.sender;
    }

    // Modifier to restrict access to the admin only
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    // Function to update the performance score of a teacher
    function updatePerformanceScore(address _teacher, uint256 _score) external onlyAdmin {
        performanceScores[_teacher] = _score;
    }

    // Function to issue rewards based on performance scores
    function issueRewards(address _teacher) external onlyAdmin {
        uint256 score = performanceScores[_teacher];
        require(score > 0, "No performance score available");

        // Simple reward calculation: 1 token per score point
        uint256 rewardAmount = score;
        require(rewardToken.transfer(_teacher, rewardAmount), "Token transfer failed");

        // Update reward balance
        rewardBalances[_teacher] += rewardAmount;

        // Emit an event for the reward issuance
        emit RewardIssued(_teacher, rewardAmount);
