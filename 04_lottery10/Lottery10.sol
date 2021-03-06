pragma solidity ^0.4.24;

/**
* @title Lottery
* @author Jan Foryś
* @notice A Lottery contract to participate for 10 people.
*/

contract Lottery10 {
   
    address[10] participants;    
    uint8 participantsCount = 0;
    uint Nonce = 0;

    /// Function that let you join the Lottery10    
    function join() public payable {

        // minimum 0.1 ether to contribute
        require(msg.value == 0.1 ether, "Must send 0.1 ether");   
        // 10 participants limit
        require(participantsCount < 10, "User limit reached");    
        // one chance to join the lottery
        require(_joinedAlready(msg.sender) == false, "User already joined"); 
        // owner of the contract can participate   
        participants[participantsCount] = msg.sender;   
        participantsCount++;
        if (participantsCount == 10) {
            _selectWinner();
        }

    }
    
    function _joinedAlready(address _participant) private view returns (bool) {
        bool containsParticipant = false;
        for (uint i = 0; i < 10; i++) {
            if (participants[i] == _participant) {
                containsParticipant == true;
            }
        }
    }
       
    /// Pick a "random" winner when we have 10 participants
    function _selectWinner() private returns (address) {

        require(participantsCount == 10, "Waiting for more users");
        address winner = participants[_randomNumber()];
        // winner gets all money
        winner.transfer(address(this).balance);    
        delete participants;
        participantsCount = 0;
        return winner;

    }
    
    function _randomNumber() private returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(msg.sender, Nonce))) % 10;
        Nonce++;
        return rand;
    }
    
}