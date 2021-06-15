// try cryptozombies here: https://cryptozombies.io/en/lesson/1/chapter/1

pragma solidity >=0.5.0 <0.6.0;

contract ZombieFactory {

    // Events are a way for your contract to communicate that something happened on the blockchain to your app front-end,
    // which can be 'listening' for certain events and take action when they happen.
    // no need to use memory with string here.
    event NewZombie(uint zombieId, string name, uint dna);
    
    // State variables are permanently stored in contract storage. This means they're written to the Ethereum blockchain.
    // Think of them like writing to a DB.
    // In Solidity, uint is actually an alias for uint256, a 256-bit unsigned integer.
    // You can declare uints with less bits — uint8, uint16, uint32, etc.. But in general you want to simply use uint except in specific cases
    uint dnaDigits = 16;
    
    // To make sure our Zombie's DNA is only 16 characters, let's make another uint equal to 10^16.
    // That way we can later use the modulus operator % to shorten an integer to 16 digits.
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }
    // When you want a collection of something, you can use an array. There are two types of arrays in Solidity: fixed arrays and dynamic arrays:
    // Array with a fixed length of 2 elements:
    // uint[2] fixedArray;
    // another fixed Array, can contain 5 strings:
    // string[5] stringArray;
    // a dynamic Array - has no fixed size, can keep growing:
    // uint[] dynamicArray; 
    // Dynamic Array, we can keep adding to it store an army of zombies in our app. And we're going to want to show off all our zombies to other apps,
    // so we'll want it to be public.
    Zombie[] public zombies;

    // Note that we're specifying the function visibility as public(changed to private).
    // We're also providing instructions about where the _name variable should be stored- in memory.
    // This is required for all reference types such as arrays, structs, mappings, and strings.
    
    // there are two ways in which you can pass an argument to a Solidity function:
    // 1. By value, which means that the Solidity compiler creates a new copy of the parameter's value and passes it to your function. (1/2)  <-- local scope
    // This allows your function to modify the value without worrying that the value of the initial parameter gets changed. (2/2)
    // 2. By reference, which means that your function is called with a... reference to the original variable. (1/2)  <-- global scope
    // Thus, if your function changes the value of the variable it receives, the value of the original variable gets changed. (2/2)
    
    // It's convention (but not required) to start function parameter variable names with an underscore (_) in order to differentiate them from global variables.
    
    // In Solidity, functions are public by default. This means anyone (or any other contract) can call your contract's function and execute its code.
    // Obviously this isn't always desirable, and can make your contract vulnerable to attacks. Thus it's good practice to mark your functions as private by default,
    // and then only make public the functions you want to expose to the world.
    
    // This means only other functions within our contract will be able to call this function and add to the numbers array.
    // As you can see, we use the keyword private after the function name. And as with function parameters,
    // it's convention to start private function names with an underscore (_).
    
    function _createZombie(string memory _name, uint _dna) private {
        // pushing to Zombie struct array. Note that array.push() adds something to the end of the array, so the elements are in the order we added them
        uint id = zombies.push(Zombie(_name, _dna)) - 1;
        emit NewZombie(id, _name, _dna);
    }
  
    // The below function doesn't actually change state in Solidity — e.g. it doesn't change any values or write anything.
    // So in this case we could declare it as a view function, meaning it's only viewing the data but not modifying it:
    
    // Solidity also contains pure functions, which means you're not even accessing any data in the app
    
    // We want our _generateRandomDna function to return a (semi) random uint.
    // Ethereum has the hash function keccak256 built in, which is a version of SHA3. A hash function basically maps an input into a random 256-bit hexadecimal number.
    // A slight change in the input will cause a large change in the hash
    // Also important, keccak256 expects a single parameter of type bytes. This means that we have to "pack" any parameters before calling keccak256
    // eg: keccak256(abi.encodePacked("aaaab"));
    // Note: Secure random-number generation in blockchain is a very difficult problem. Our method here is insecure.
    // Sometimes need to convert between data types
    /**
    uint8 a = 5;
    uint b = 6;
    // throws an error because a * b returns a uint, not uint8:
    uint8 c = a * b;
    // we have to typecast b as a uint8 to make it work:
    uint8 c = a * uint8(b);
    **/
    function _generateRandomDna(string memory _str) private view returns (uint) { 
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function createRandomZombie(string memory _name) public {
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }

}
