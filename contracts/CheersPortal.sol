// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract CheersPortal {
    uint256 totalCheers;
    uint256 private seed;

    event NewCheers(address indexed from, string message, uint256 timestamp);

    struct Cheers {
        address user;
        string message;
        uint256 timestamp;
    }

    Cheers[] cheersList;

    /*
     * This is an address => uint mapping, meaning I can associate an address with a number!
     * In this case, I'll be storing the address with the last time the user cheered us.
     */
    mapping(address => uint256) public lastCheersAt;

    constructor() payable {
        console.log("Cheers to a smart contract!");

        /*
         * Set the initial seed (between 1-100)
         */
        seed = (block.timestamp + block.difficulty) % 100;
    }

    function cheers(string memory _message) public {
        /*
         * Ensure the current timestamp is at least 15-minutes bigger than the last timestamp we stored
         */
        require(
            lastCheersAt[msg.sender] + 15 minutes < block.timestamp,
            "Wait 15m"
        );

        /*
         * Update the current timestamp we have for the user
         */
        lastCheersAt[msg.sender] = block.timestamp;

        /*
         * Increase total cheers amount
         */
        totalCheers += 1;
        console.log("%s cheers with message %s", msg.sender, _message);

        /*
         * Add new message to the list
         */
        cheersList.push(Cheers(msg.sender, _message, block.timestamp));

        /*
         * Generate a new seed for the next user that sends a wave
         */
        seed = (block.difficulty + block.timestamp + seed) % 100;
        console.log("Random seed generated: %d", seed);

        /*
         * Give a 50% chance that the user wins the prize.
         */
        if (seed <= 50) {
            console.log("%s won!", msg.sender);

                uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
        }

        /*
         * Return newest message
         */
        emit NewCheers(msg.sender, _message, block.timestamp);
    }

    function getAllCheers() public view returns (Cheers[] memory) {
        return cheersList;
    }

    function getTotalCheers() public view returns (uint256) {
        console.log("We have %d total cheers!", totalCheers);
        return totalCheers;
    }
}
