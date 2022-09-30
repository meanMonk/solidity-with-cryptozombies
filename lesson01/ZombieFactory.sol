// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;


/// @title Zombie Factory to create zombies from cryptozombies tutorial
/// @author Sahil Kashetwar
/// @notice It's factory function to create army of zombie lesson one.
/// @dev please go throug the docs and respect implementation.
contract ZombieFactory {
  
  /// @notice Event to be trigger when new zombie created to listen on dapp or frontend.
  /// @dev Event which is getting triggered when new zombie created.
  /// @param zombieId a parameter which defines id
  /// @param name a parameter which defines name
  /// @param dna a parameter which defines dna
  event NewZombie(uint zombieId, string name, uint dna);
  
  /// @notice variable internal to contract state to hold the digits
  /// @dev we have two var to hold the values dnaDigits and dnaModulus to prepare random data.
  uint dnaDigits = 16;
  uint dnaModulus = 10 ** dnaDigits;
  
  ///@notice this is struct which defines the schema of Zombie; 
  ///@dev this is struct which defines the schema of Zombie; 
  struct Zombie {
    string name;
    uint dna;
  }
  
  ///@notice all zombies can be access via zombies publically;
  ///@dev array list which holds zombies info.
  Zombie[] public zombies;
  
  // mappings
  mapping (uint => address) public zombieToOwner;
  mapping (address => uint) ownerZombieCount;
  
  /// @notice Private function to create new zombie and trigger event.
  /// @dev private functions used to create and update zombies arrays with new zombie and dna.
  /// @param _name is name of new zombie
  /// @param _dna randomly generated 16 digit has 
  
  function _createNewZombie(string memory _name, uint _dna) internal {
    zombies.push(Zombie(_name, _dna)); // return new length of array and length - 1 will be id;
    uint id = zombies.length - 1;
    zombieToOwner[id] = msg.sender;
    ownerZombieCount[msg.sender]++;
    emit NewZombie(id, _name, _dna);
  }
  
  /// @notice generate random dna.
  /// @dev Explain to a developer any extra details
  /// @param _str a parameter which is name of new zombie
  /// @return uint 16digit random hash w.r.to. provided param _str.
  
  function _generateRandomDna(string memory _str) private view returns (uint) {
    uint rand = uint(keccak256(abi.encodePacked(_str))); // generating the random number out of with sha3 algo.
    return rand % dnaModulus; // as we need to have 16 digit hash.
  }
  
  
  /// @notice Public function which can be trigger any using contract to create random zombies
  /// @dev Public function to create random zombies 
  /// @param _str a parameter to create random zombie char.
  
  function createRandomZombie(string memory _str) public {
    uint randDna = _generateRandomDna(_str);
    _createNewZombie(_str, randDna);
  }
  
}