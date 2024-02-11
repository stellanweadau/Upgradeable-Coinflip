// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

error SeedTooShort();

/// @title Coinflip 10 in a Row
/// @author Stellan WEA
/// @notice Contract used as part of the course Solidity and Smart Contract development
contract Coinflip is Initializable, OwnableUpgradeable, UUPSUpgradeable {
    
    constructor(address initialOwner) Ownable(initialOwner) {}
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(address initialOwner) initializer public {
        __Ownable_init(initialOwner);
        __UUPSUpgradeable_init();
    }

    function _authorizeUpgrade(address newImplementation)
        internal
        onlyOwner
        override
    {}

    uint randomNum = 0;
    string public seed;

    constructor() Ownable(msg.sender) {
        // TO: set the seed to "It is a good practice to rotate seeds often in gambling".
        seed = "It is a good practice to rotate seeds often in gambling";
    }

    function userInput(uint8[10] calldata Guesses) external view returns(bool){
        // TO: Get the contract generated flips by calling the helper function getFlips()
        // TO: Compare each element of the user's guesses with the generated guesses. Return true ONLY if all guesses match
        
        uint8[10] memory trueResults = getFlips();

        for (uint i=0; i < Guesses.length; i++) {
            
            if (Guesses[i] != trueResults[i]) {
                return false;
            }
        
        }
        return true; //We reach this code only if we've never entered in the if statement above

        
    }

    // @notice allows the owner of the contract to change the seed to a new one
    // @param a string which represents the new seed
    function seedRotation(string memory NewSeed) public onlyOwner {
        // TO: Cast the string into a bytes array so we may perform operations on it
        bytes memory seedBytes = bytes(seed);

        // TO: Get the length of the array (ie. how many characters in this string)
        uint seedLength = seedBytes.length;

        // Check if the seed is less than 10 characters (This function is given to you)
        if (seedLength < 10){
            revert SeedTooShort();
        }
        
        //TO: Set the seed variable as the NewSeed
        seed = NewSeed;
    }

// -------------------- helper functions -------------------- //
    // @notice This function generates 10 random flips by hashing characters of the seed
    // @param No input as only the seed is used for generating the guesses
    // @return a fixed 10 element array of type uint8 with only 1 or 0 as its elements
    function getFlips() public view returns(uint8[10] memory){
        // TO: Cast the seed into a bytes array and get its length
        bytes memory seedBytes = bytes(seed);
        uint seedLength = seedBytes.length;

        // TO: Initialize an empty fixed array with 10 uint8 elements
        uint8[10] memory flips;

        // Setting the interval for grabbing characters
        uint interval = seedLength / 10;

        // TO: Input the correct form for the for loop
        for (uint i=0; i < seedLength; i++){
            // Generating a pseudo-random number by hashing together the character and the block timestamp
            uint randomNum = uint(keccak256(abi.encode(stringInBytes[i*interval], block.timestamp)));
            
            // TO: if the result is an even unsigned integer, record it as 1 in the results array, otherwise record it as zero
            if (randomNum %2 == 0 && randomNum >=0 ) {
                flips[i] = 1;
            } else {
                flips[i] = 0;
            }
        }

        //TO: return the resulting fixed array

        return flips;
    }
}