// SPDX-License-Identifier: GPL-3.0

// specfies the version of solidity that our code is going to use. make sure to use a specific version only(use ^0.9.0).
pragma solidity >=0.7.0 <0.9.0;

// defines new contract that will have some number of methods or variables. similar to class in java or python
contract Inbox {
    
    // Instance variable(global variable)
    string public message;
    
    // This is the constructor which registers initial message. one time execution
    constructor(string memory initialMessage) {
        message = initialMessage;
    }
    
    /*
    function visibility(func type):-
     1. external: External functions are part of the contract interface, which means they can be called from other contracts and via transactions.
       // An external function f cannot be called internally (i.e. f() does not work, but this.f() works)
     2. internal: Those functions and state variables can only be accessed internally (i.e. from within the current contract or contracts deriving from it),
        without using this. This is the default visibility level for state variables.   
     3. public: anyone can call this function
     4. private: only our contract can call this function
     5. view: this function returns data and doesn't modify the contracts data
     6. constant: same as above <-- deprecated or changed to view type
     7. pure: func will not modify and read the contract's data 
     8. payable: when some call this func they might send some ethers along.
     */
    
    function setMessage(string memory newMessage) public {
        message = newMessage;
    }
    
    //       |func name|  |func type| |    return type      |
    function getMessage() public view returns (string memory) {
        return message;
    }
}
