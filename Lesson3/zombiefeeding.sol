pragma solidity ^0.8.5;

import "./zombiefactory.sol";

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
1. Here we removed the hardcoded cryptokitties address and using setKittyContractAdress function which allow us
    to change this address in the future in case something happens to the CryptoKitties contract.
2. setKittyContractAddress is set to external hence anyone can call it. That means anyone who called the function
    could change the address of the CryptoKitties contract, and break our app for all its users. We do want the 
    ability to update this address in our contract, but we don't want everyone to be able to update it. To handle 
    cases like this, one common practice that has emerged is to make contracts Ownable — meaning they have an
    owner (you) who has special privileges. We are using OpenZeppelin's Ownable.sol contract to fix this. 
    Ref: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
    Import the above contract in zombiefactory.sol and then using `onlyOwner` modifier to restrict this function to
    the owner only.
3. function modifier :- A function modifier looks just like a function, but uses the keyword modifier instead of 
    the keyword function. And it can't be called directly like a function can — instead we can attach the 
    modifier's name at the end of a function definition to change that function's behavior.
    for eg: Notice the onlyOwner modifier on the setKittyContractAddress function. When you call setKittyContractAddress, 
            the code inside onlyOwner executes first. Then when it hits the _; statement in onlyOwner, it goes 
            back and executes the code inside setKittyContractAddress.
 */
contract ZombieFeeding is ZombieFactory {
  // declared KittyInterface
  KittyInterface kittyContract;

  function setKittyContractAddress(address _address) external onlyOwner {
    kittyContract = KittyInterface(_address);
  }

/**
Passing structs as arguments :- 
You can pass a storage pointer to a struct as an argument to a private or internal function. This is useful, for example, 
for passing around our Zombie structs between functions. This way we can pass a reference to our zombie into a function instead 
of passing in a zombie ID and looking it up.
*/
  function _triggerCooldown(Zombie storage _zombie) internal {
    _zombie.readyTime = uint32(block.timestamp + cooldownTime);
  }

/** 
1. when a function is called by within same contract then make it private and when a function is called by inherited contract 
    then make it internal.
2. here feedAndMultiply is called by feedOnKitty function and hence can be made internal
*/
  function feedAndMultiply(uint _zombieId, uint _targetDna, string memory _species) public {
    require(msg.sender == zombieToOwner[_zombieId]);
    Zombie storage myZombie = zombies[_zombieId];
    _targetDna = _targetDna % dnaModulus;
    uint newDna = (myZombie.dna + _targetDna) / 2;
    if (keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))) {
      newDna = newDna - newDna % 100 + 99;
    }
    _createZombie("NoName", newDna);
    _triggerCooldown(myZombie);
  }

  function feedOnKitty(uint _zombieId, uint _kittyId) public {
    uint kittyDna;
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
    feedAndMultiply(_zombieId, kittyDna, "kitty");
  }

}
