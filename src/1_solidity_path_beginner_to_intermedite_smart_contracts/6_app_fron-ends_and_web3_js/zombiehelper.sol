pragma solidity >=0.5.0 <0.6.0;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {

uint levelUpFee = 0.001 ether;

modifier aboveLevel(uint _level, uint _zombieId) {
    require(zombies[_zombieId].level >= _level);
    _;
}

function withdraw() external onlyOwner {
  address payable _owner = address(uint160(owner())); // to receive money an address needs to be payable
  _owner.transfer(address(this).balance);
}

function setLevelUpFee(uint _fee) external onlyOwner {
  levelUpFee = _fee;
}

function levelUp(uint _zombieId) external payable { // payable function
  require(msg.value == levelUpFee); // require fee payment
  zombies[_zombieId].level++;
}

function changeName(uint _zombieId, string calldata _newName) external aboveLevel(2, _zombieId) ownerOf(_zombieId) { // calldata similar to memory but only for external functions 
    zombies[_zombieId].name = _newName;
}

function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId) ownerOf(_zombieId) {
    zombies[_zombieId].dna = _newDna;
}

function getZombiesByOwner(address _owner) external view returns(uint[] memory) { // view functions retrieve informations from the blockchain for free
    uint[] memory result = new uint[](ownerZombieCount[_owner]); // creation of an empty array
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
