pragma solidity ^0.8.5;

import "./zombiefeeding.sol";

/**
L3 C09
function modifiers with arguments :- It is possible to send the arguments with function modifiers.
You can see here that the aboveLevel modifier takes arguments just like a function does. 
And that the chnageName and changeDna functions passes its arguments to the modifier.
*/
contract ZombieHelper is ZombieFeeding {

  modifier aboveLevel(uint _level, uint _zombieId) {
    require(zombies[_zombieId].level >= _level);
    _;
  }

  function changeName(uint _zombieId, string calldata _newName) external aboveLevel(2, _zombieId) {
    require(msg.sender == zombieToOwner[_zombieId]);
    zombies[_zombieId].name = _newName;
  }

  function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId) {
    require(msg.sender == zombieToOwner[_zombieId]);
    zombies[_zombieId].dna = _newDna;
  }

/**
L3 C10
1. view :- functions don't cost any gas when they're called externally by a user.
2. This is because view functions don't actually change anything on the blockchain – 
    they only read the data. So marking a function with view tells web3.js that it only needs
    to query your local Ethereum node to run the function, and it doesn't actually have to
    create a transaction on the blockchain (which would need to be run on every single node, and cost gas).
3. Note: If a view function is called internally from another function in the same contract that is not a
    view function, it will still cost gas. This is because the other function creates a transaction on 
    Ethereum, and will still need to be verified from every node. So view functions are only free when 
    they're called externally.

L3 C11
Storage is expensive :- One of the more expensive operations in Solidity is using storage — particularly writes.
1. This is because every time you write or change a piece of data, it’s written permanently to the blockchain. 
    Forever! Thousands of nodes across the world need to store that data on their hard drives, and this amount 
    of data keeps growing over time as the blockchain grows. So there's a cost to doing that.
2. In order to keep costs down, you want to avoid writing data to storage except when absolutely necessary.
    Sometimes this involves seemingly inefficient programming logic — like rebuilding an array in memory every 
    time a function is called instead of simply saving that array in a variable for quick lookups.
3. In most programming languages, looping over large data sets is expensive. But in Solidity, this is way 
    cheaper than using storage if it's in an external view function, since view functions don't cost your users any gas.
4. You can use the memory keyword with arrays to create a new array inside a function without needing to 
    write anything to storage. The array will only exist until the end of the function call, and this is a 
    lot cheaper gas-wise than updating an array in storage — free if it's a view function called externally.
5. A memory array is an array created within a function. Because it is part of the memory, it is not persistent,
    so the array is erased after the function has executed. To create a a memory array, use the new keyword.
6. Note that you can’t assign a fixed-size memory array to a dynamic size memory array.
eg: 
    function testArray() public {
        uint[] memory x = [uint(1), 3, 4];
    }
    will result in an error --> TypeError: Type uint256[3] memory is not implicitly convertible to expected type uint256[] memory. 
7. Note that you can’t change the size of memory arrays by assigning values to the member .length because their length is fixed 
    once created. You can only change the `.length` of an array if it is refered as storage.
8. If an array is returned by a function, the data location specified always have to be memory.
9. You cannot return an array of mappings in Solidity.

Ref :- https://jeancvllr.medium.com/solidity-tutorial-all-about-array-efdff4613694    
*/
  function getZombiesByOwner(address _owner) external view returns(uint[] memory) {
    uint[] memory result = new uint[](ownerZombieCount[_owner]);
    // Start here
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
