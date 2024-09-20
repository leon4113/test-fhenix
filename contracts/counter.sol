// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@fhenixprotocol/contracts/FHE.sol";
import {Permissioned, Permission} from "@fhenixprotocol/contracts/access/Permissioned.sol";

contract Counter is Permissioned {
    mapping(address => euint32) private _encBalances;
    event TokensWrapped(address indexed account, uint32 publicAmount, euint32 encryptedAmount);
    event Received(address sender, uint256 amount);
    event FallbackTriggered(address sender, uint256 amount, bytes data);

    // Wrap function that encrypts and converts public tokens to private tokens
    function wrap(uint32 amount) public {
        // Make sure that the sender has enough of the public balance
        require(balanceOf(msg.sender) >= amount);
        // Burn public balance
        _burn(msg.sender, amount);

        // convert public amount to shielded by encrypting it
        euint32 shieldedAmount = FHE.asEuint32(amount);
        // Add shielded balance to his current balance
        _encBalances[msg.sender] = _encBalances[msg.sender] + shieldedAmount;
    }

    // Receive function to handle incoming Ether
    receive() external payable {
        emit Received(msg.sender, msg.value);  // Emit event when Ether is received
    }

    // Fallback function to handle non-existent function calls and unexpected data
    fallback() external payable {
        emit FallbackTriggered(msg.sender, msg.value, msg.data);  // Emit event for fallback
    }

    // Helper function to simulate getting the public balance (for demo purposes)
    function balanceOf(address account) public pure returns (uint256) {
        return 100; // Simulating the user having 100 tokens
    }

    // Helper function to simulate burning the public tokens
    function _burn(address account, uint256 amount) internal {
        // Burn logic (for demo purposes)
    }

    // Getter function to view the encrypted balance of a user
    function getEncryptedBalance(address account) public view returns (euint32) {
        return _encBalances[account];
    }
}
