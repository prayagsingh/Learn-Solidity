pragma solidity ^0.8.5;

contract ZombieFactory {

    event NewZombie(uint zombieId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    // mapping like a map in golang or dict in python
    mapping (uint => address) public zombieToOwner;
    mapping (address => uint) ownerZombieCount;

    /**
    --> msg.sender
    In Solidity, there are certain global variables that are available to all functions.
    One of these is msg.sender, which refers to the address of the person (or smart contract) who called the current function.
    Note: In Solidity, function execution always needs to start with an external caller.
          A contract will just sit on the blockchain doing nothing until someone calls one of its functions.
          So there will always be a msg.sender.

    --> Internal and External functions:
    1. In addition to public and private, Solidity has two more types of visibility for functions: internal and external.
    2. internal is the same as private, except that it's also accessible to contracts that inherit from this contract.
    3. External is similar to public, except that these functions can ONLY be called outside the contract — they can't
        be called by other functions inside that contract. We'll talk about why you might want to use external vs public later.
    4. For declaring internal or external functions, the syntax is the same as private and publi
    */
    function _createZombie(string memory _name, uint _dna) internal {
        zombies.push(Zombie(_name, _dna));
        uint id = zombies.length - 1; 
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++;
        emit NewZombie(id, _name, _dna);
    }

    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }
    /**
    require is quite useful for verifying certain conditions that must be true before running a function.
     */
    function createRandomZombie(string memory _name) public {
        require(ownerZombieCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        randDna = randDna - randDna % 100;
        _createZombie(_name, randDna);
    }

}
