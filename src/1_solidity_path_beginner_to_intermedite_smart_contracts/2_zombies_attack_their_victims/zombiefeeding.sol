pragma solidity >=0.5.0 <0.6.0;

import "./zombiefactory.sol"; // import modules

contract KittyInterface {   // interface to CryptoKitties DApp
  function getKitty(uint256 _id) external view returns ( // only the interface functions are mentioned in the contract interface
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

contract ZombieFeeding is ZombieFactory {

  address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d; // CryptoKitties contract address
  KittyInterface kittyContract = KittyInterface(ckAddress); // interface initialization

  function feedAndMultiply(uint _zombieId, uint _targetDna, string memory _species) public {
    require(msg.sender == zombieToOwner[_zombieId]);
    Zombie storage myZombie = zombies[_zombieId]; // Storage refers to variables stored permanently on the blockchain. Memory variables are temporary, and are erased between external function calls to your contract
    _targetDna = _targetDna % dnaModulus;
    uint newDna = (myZombie.dna + _targetDna) / 2; // DNA ricombination

    if (keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))) {
      newDna = newDna - newDna % 100 + 99; // add 99 at the end of the DNA
    }

    _createZombie("NoName", newDna);
  }

   function feedOnKitty(uint _zombieId, uint _kittyId) public {
    uint kittyDna;
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId); // multiple returns 

    feedAndMultiply(_zombieId, kittyDna, "kitty");
  }
 

}