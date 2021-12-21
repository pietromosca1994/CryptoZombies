pragma solidity >=0.5.0 <0.6.0; // solidity version     

contract ZombieFactory {

    event NewZombie(uint zombieId, string name, uint dna); // Events are a way for your contract to communicate that something happened on the blockchain to your app front-end, which can be 'listening' for certain events and take action when they happen. 
    
    // This will be stored permanently in the blockchain
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies; // dynamic array, Solidity automatically creates a getter method for a public array

    function _createZombie(string memory _name, uint _dna) private {
        uint id = zombies.push(Zombie(_name, _dna)) - 1; // push adds to the array
        emit NewZombie(id, _name, _dna);
    }

    function _generateRandomDna(string memory _str) private view returns (uint) { // str should be stored in memory (required for all reference types such as arrays, structs, mappings, and strings )
        uint rand = uint(keccak256(abi.encodePacked(_str))); // kekkak256 is an Ethereum built in hash function (version of SHA3), abi.encodePacked return packed of type byte
        return rand % dnaModulus; // % modulus/remainder
    }

    function createRandomZombie(string memory _name) public {
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }

}
