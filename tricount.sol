// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.16;

contract Auction {

    mapping(address => int) public balances;
    address[] addresses;
    event Messages(string _message);
    event insertedAdresses(address);

    constructor(address[] memory addresses_) {
        addresses = addresses_;
        for (uint i = 0; i < addresses_.length; i++) {
            balances[addresses_[i]] = 0;
        }
        emit Messages("Created...");
    }


    function addAmount(int amount) public {
        balances[msg.sender] = balances[msg.sender] + amount;
        int amountToDiscount = amount / (int(addresses.length) - 1);
        for (uint i = 0; i < addresses.length; i++) {
            emit Messages("Iterated");
            if (addresses[i] != msg.sender) {
                balances[addresses[i]] = balances[addresses[i]] - amountToDiscount;
            }
        }
    }

    function getAdresses() public {
        for (uint i = 0; i < addresses.length; i++) {
            emit insertedAdresses(addresses[i]);
        }
    }

    function getAdressesBalances() public {
        for (uint i = 0; i < addresses.length; i++) {
            emit insertedAdresses("Adress",addresses[i]);
        }
    }
    
}

//["0x5B38Da6a701c568545dCfcB03FcB875f56beddC4", "0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2"]