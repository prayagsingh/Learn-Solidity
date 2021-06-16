pragma solidity ^0.8.5;

// if using inheritance and contracts are in different files and need to use import the Parent contract file
import "./zombiefactory.sol";

/**
--> Interacting with external contracts
1. For our contract to talk to another contract on the blockchain that we don't own, first we need to define an interface.
2. First we'd have to define an interface of the CryptoKitties contract.
3. this looks like defining a contract, with a few differences. For one, we're only declaring the functions
    we want to interact with — in this case getKitty — and we don't mention any of the other functions or state variables.
4. Secondly, we're not defining the function bodies. Instead of curly braces ({ and }),
    we're simply ending the function declaration with a semi-colon (;).
5. So it kind of looks like a contract skeleton. This is how the compiler knows it's an interface.
 */
interface KittyInterface {
  function getKitty(uint256 _id) external view returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
  );
}

/**
Inheritance --> `contract ZombieFeeding is ZombieFactory`
ZombieFeeding inherits ZombieFactory. ZombieFeeding can call all the public and internal functiions from ZombieFactory
 but not the private ones.
Here we don't have to compile ZombieFactory anymore since it is inherited by ZombieFeeding 
*/

/**
chapter 7: https://cryptozombies.io/en/lesson/2/chapter/7
Zombie storage myZombie = zombies[_zombieId];
1. In Solidity, there are two locations you can store variables — in storage and in memory.
2. Storage refers to variables stored permanently on the blockchain. Memory variables are temporary,
     and are erased between external function calls to your contract. Think of it like your computer's hard disk vs RAM.
3. Most of the time you don't need to use these keywords because Solidity handles them by default.
4. State variables (variables declared outside of functions) are by default storage and written permanently
    to the blockchain, while variables declared inside functions are memory and will disappear when the function call ends.
*/
contract ZombieFeeding is ZombieFactory {
  // Using an Interface
  // below is the address of CryptoKitty contract
  address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
  
  // Now `kittyContract` is pointing to the other contract
  KittyInterface kittyContract = KittyInterface(ckAddress);

  function feedAndMultiply(uint _zombieId, uint _targetDna, string memory _species) public {
    require(msg.sender == zombieToOwner[_zombieId]);
    Zombie storage myZombie = zombies[_zombieId];
    _targetDna = _targetDna % dnaModulus;
    uint newDna = (myZombie.dna + _targetDna) / 2;
    if (keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))) {
      newDna = newDna - newDna % 100 + 99;
    }
    _createZombie("NoName", newDna);
  }

  function feedOnKitty(uint _zombieId, uint _kittyId) public {
    uint kittyDna;
    // Now we can call `getKitty` from that contract and we need only `genes` from cryptokitty contract. 
    // This cryptokitty contract returns multiple values and since we only need `genes` hence added commas(,)
    // and only storing the value of `genes` to `kittyDna` contract
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
    feedAndMultiply(_zombieId, kittyDna, "kitty");
  }

}
