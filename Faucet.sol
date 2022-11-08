// SPDX-License-Identifier: MIT
// Author: Khiemnhh
pragma solidity 0.8.2;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Faucet is Ownable{
    
    // address owner;
    mapping (address => uint) timeouts;
    
    event Withdrawal(address indexed to);
    event Deposit(address indexed from, uint amount);
    
    //  Sends 0.1 ETH to the sender when the faucet has enough funds
    //  Only allows one withdrawal every 30 mintues
    function withdraw() external{
        
        require(address(this).balance >= 0.1 ether, "This faucet is empty. Please check back later.");
        require(timeouts[msg.sender] <= block.timestamp - 30 minutes, "You can only withdraw once every 30 minutes. Please check back later.");
        
        payable(msg.sender).transfer(0.1 ether);
        timeouts[msg.sender] = block.timestamp;
        
        emit Withdrawal(msg.sender);
    }
    
    //  Sending Tokens to this faucet fills it up
    // receive() external payable {
    //     emit Deposit(msg.sender, msg.value); 
    // } 

    function deposit() external payable {
        emit Deposit(msg.sender, msg.value); 
    }
    
    
    //  Destroys this smart contract and sends all remaining funds to the owner
    function destroy() public onlyOwner{
        selfdestruct(payable(msg.sender));
    }
}