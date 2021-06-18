pragma solidity ^0.8.5;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.1.0/contracts/access/Ownable.sol";

/**
Saving Gas :-
1. In earlier lesson, we learnt that there are other types of uints: uint8, uint16, uint32, etc.
2. Normally there's no benefit to using these sub-types because Solidity reserves 256 bits of storage 
   regardless of the uint size. For example, using uint8 instead of uint (uint256) won't save you any gas.
3. But there's an exception to this: inside structs. If you have multiple uints inside a struct, using a 
   smaller-sized uint when possible will allow Solidity to pack these variables together to take up less storage.
4. For this reason, inside a struct you'll want to use the smallest integer sub-types and You'll also want to 
   cluster identical data types together (i.e. put them next to each other in the struct) so that Solidity can 
   minimize the required storage space. For example, a struct with fields uint c; uint32 a; uint32 b; will cost 
   less gas than a struct with fields uint32 a; uint c; uint32 b; because the uint32 fields are clustered together.   
 */

contract ZombieFactory is Ownable {

    event NewZombie(uint zombieId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    // an amount of time a zombie has to wait after feeding or attacking before it's allowed to feed / attack again. 
    // Without this, the zombie could attack and multiply 1,000 times per day, which would make the game way too easy.
    uint cooldownTime = 1 days;

    struct Zombie {
      string name;
      uint dna;
      uint32 level;
      uint32 readyTime;
    }

    Zombie[] public zombies;

    mapping (uint => address) public zombieToOwner;
    mapping (address => uint) ownerZombieCount;

    function _createZombie(string memory _name, uint _dna) internal {
        zombies.push(Zombie(_name, _dna, 1, uint32(block.timestamp + cooldownTime)));
        uint id = zombies.length - 1;
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++;
        emit NewZombie(id, _name, _dna);
    }

    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function createRandomZombie(string memory _name) public {
        require(ownerZombieCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        randDna = randDna - randDna % 100;
        _createZombie(_name, randDna);
    }

}
