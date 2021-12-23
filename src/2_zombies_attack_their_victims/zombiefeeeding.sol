pragma solidity >=0.5.0 <0.6.0;

import "./zombiefactory.sol"; // import modules

contract ZombieFeeding is ZombieFactory {

  function feedAndMultiply(uint _zombieId, uint _targetDna) public {
    require(msg.sender == zombieToOwner[_zombieId]);
    Zombie storage myZombie = zombies[_zombieId]; // Storage refers to variables stored permanently on the blockchain. Memory variables are temporary, and are erased between external function calls to your contract
    _targetDna = _targetDna % dnaModulus;
    uint newDna = (myZombie.dna + _targetDna) / 2; // dna ricombination
    _createZombie("NoName", newDna);
  }

}