pragma solidity ^0.8.5;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {

  uint levelUpFee = 0.001 ether;

  modifier aboveLevel(uint _level, uint _zombieId) {
    require(zombies[_zombieId].level >= _level);
    _;
  }
/** 
Payable Modifier :- are a special type of function that can receive Ether.
--> msg.value is a way to see how much Ether was sent to the contract, and ether is a built-in unit.
--> If a function is not marked payable and you try to send Ether to it as above, the function will reject your transaction.
--> After you send Ether to a contract, it gets stored in the contract's Ethereum account, and it will be trapped there — 
    unless you add a function to withdraw the Ether from the contract.
--> Here `owner()` and `onlyOwner` are from OpenZeppelin's `Ownable.sol` smart-contract.
--> most important for _owner variable that it's have to be a address payable type for doing a sending and transferring
    ether instruction.
--> You can transfer Ether to an address using the transfer function, and address(this).balance will return the total 
    balance stored on the contract. So if 100 users had paid 1 Ether to our contract, address(this).balance would 
    equal 100 Ether.
--> You can use transfer to send funds to any Ethereum address. For example, you could have a function that transfers 
    Ether back to the msg.sender if they overpaid for an item    
*/
  function withdraw() external onlyOwner {
    // https://docs.soliditylang.org/en/v0.8.3/types.html#addresses
    //address payable _owner = payable(address(uint160(owner())));
    address payable _owner = payable((owner())); // owner() returns msg.sender and need to convert it into payable
    _owner.transfer(address(this).balance);
  }

  function setLevelUpFee(uint _fee) external onlyOwner {
    levelUpFee = _fee;
  }

  function levelUp(uint _zombieId) external payable {
    require(msg.value == levelUpFee);
    zombies[_zombieId].level++;
  }

  function changeName(uint _zombieId, string calldata _newName) external aboveLevel(2, _zombieId) ownerOf(_zombieId) {
    zombies[_zombieId].name = _newName;
  }

  function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId) ownerOf(_zombieId) {
    zombies[_zombieId].dna = _newDna;
  }

  function getZombiesByOwner(address _owner) external view returns(uint[] memory) {
    uint[] memory result = new uint[](ownerZombieCount[_owner]);
    uint counter = 0;
    for (uint i = 0; i < zombies.length; i++) {
      if (zombieToOwner[i] == _owner) {
        result[counter] = i;
        counter++;
      }
    }
    return result;
  }

}
