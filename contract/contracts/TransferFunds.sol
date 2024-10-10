// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/**
 * @title TransferFunds
 * @author 0xOse
 * @notice This contract allows users to transfer funds and stores the transaction history.
 */
contract TransferFunds {
    uint256 transactionCount; // Keeps track of the total number of transactions

    /**
     * @dev Emitted when a transfer is made.
     * @param from The address of the sender.
     * @param receiver The address of the receiver.
     * @param amount The amount of the transfer.
     * @param message A message associated with the transfer.
     * @param timestamp The timestamp of the transfer.
     */
    event TransferEvent(
        address from,
        address receiver,
        uint256 amount,
        string message,
        uint256 timestamp
    );

    /**
     * @dev Struct to represent a transfer.
     * @param sender The address of the sender.
     * @param receiver The address of the receiver.
     * @param amount The amount of the transfer.
     * @param message A message associated with the transfer.
     * @param timestamp The timestamp of the transfer.
     */
    struct TransferFundsStruck {
        address sender;
        address receiver;
        uint256 amount;
        string message;
        uint256 timestamp;
    }

    TransferFundsStruck[] transactions; // Array to store all transactions

    /**
     * @dev Adds a new transfer to the blockchain.
     * @param receiver The address of the receiver.
     * @param amount The amount of the transfer.
     * @param message A message associated with the transfer.
     */
    function addDataToBlockchain(
        address payable receiver,
        uint256 amount,
        string memory message
    ) public {
        transactionCount += 1;
        transactions.push(
            TransferFundsStruck(
                msg.sender,
                receiver,
                amount,
                message,
                block.timestamp
            )
        );

        emit TransferEvent(
            msg.sender,
            receiver,
            amount,
            message,
            block.timestamp
        );
    }

    /**
     * @dev Returns all transactions.
     * @return An array of all transactions.
     */
    function getAllTransactions()
        public
        view
        returns (TransferFundsStruck[] memory)
    {
        return transactions;
    }

    /**
     * @dev Returns the total number of transactions.
     * @return The total number of transactions.
     */
    function getTransactionCount() public view returns (uint256) {
        return transactionCount;
    }
}
