// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.16;

contract Auction {

    struct Balance {
        int amount;
        bool exists;
    }

    mapping(address => Balance) public balances;
    address[] adresses;
    event Messages(string _message);
    event insertedAdresses(address);
    event insertedAdressesBalances(address,int);

    constructor(address[] memory adresses_) {
        adresses = adresses_;
        for (uint i = 0; i < adresses_.length; i++) {
            balances[adresses_[i]] = Balance(0, true);
        }
    }

    function addAmount(int amount) public {
        require(adressExistsInBalance(), "Address does no exists in balances");
        addAmountToAccount(msg.sender, amount);
        int amountToDiscount = amount / (int(adresses.length) - 1);
        for (uint i = 0; i < adresses.length; i++) {
            if (adresses[i] != msg.sender) {
                discountAmountToAccount(adresses[i], amountToDiscount);
            }
        }
    }

    function adressExistsInBalance() public view returns(bool){
        return balances[msg.sender].exists;
    }

    function addAmountToAccount(address expectedAddress, int amount) private {
        balances[expectedAddress].amount = balances[expectedAddress].amount + amount;
    }

    function discountAmountToAccount(address expectedAddress, int amount) private {
        balances[expectedAddress].amount = balances[expectedAddress].amount - amount;
    } 

    function getAdresses() public {
        for (uint i = 0; i < adresses.length; i++) {
            emit insertedAdresses(adresses[i]);
        }
    }

    function getAdressesBalances() public {
        for (uint i = 0; i < adresses.length; i++) {
            emit insertedAdressesBalances(adresses[i],balances[adresses[i]].amount);
        }
    }
    
}

//["0x5B38Da6a701c568545dCfcB03FcB875f56beddC4", "0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2"]