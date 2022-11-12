// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.16;

contract Auction {

    struct Balance {
        int amount;
        bool exists;
    }

    struct BalanceToDiscount {
        address addressToDiscount;
        int amountToDiscount;
    }

    mapping(address => Balance) public balances;
    address[] adresses;
    event insertedAdresses(address);
    event insertedAdressesBalances(address,int);

    constructor(address[] memory adresses_) {
        adresses = adresses_;
        for (uint i = 0; i < adresses_.length; i++) {
            balances[adresses_[i]] = Balance(0, true);
        }
    }

    function addAmount(int amount, BalanceToDiscount[] memory balancesToDiscount) public {
        require(adressExistsInBalance(), "Address does not exists in balances");
        require(amountsMatchWithTotal(amount, balancesToDiscount), "Amounts to discount does not match with the total one");
        addAmountToAccount(msg.sender, amount);
        if (balancesToDiscount.length != 0) {
            discountToDefinedBalances(balancesToDiscount);
        } else {
            discountToAllBalances(amount);
        }
        
    }

    function adressExistsInBalance() public view returns(bool){
        return balances[msg.sender].exists;
    }

    function amountsMatchWithTotal(int totalAmount, BalanceToDiscount[] memory balancesToDiscount) private pure returns(bool) {
        if (balancesToDiscount.length == 0) {
            return true;
        }
        int totalAmountsToDiscount = 0;
        for (uint i = 0; i < balancesToDiscount.length; i++) {
            totalAmountsToDiscount += balancesToDiscount[i].amountToDiscount;
        }
        return totalAmount == totalAmountsToDiscount;
    }

    function discountToAllBalances(int amount) private {
        int amountToDiscount = amount / (int(adresses.length) - 1);
        for (uint i = 0; i < adresses.length; i++) {
            if (adresses[i] != msg.sender) {
                discountAmountToAccount(adresses[i], amountToDiscount);
            }
        }
    }

    function discountToDefinedBalances(BalanceToDiscount[] memory balancesToDiscount) private {
        for (uint i = 0; i < balancesToDiscount.length; i++) {
            if (adresses[i] != msg.sender) {
                discountAmountToAccount(balancesToDiscount[i].addressToDiscount, balancesToDiscount[i].amountToDiscount);
            }
        }
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

    //TODO fixear constructor de forma que reciba el numero de users que queremos introducir
    //Crear funciones de addUser y deleteUser
    
}

//["0x5B38Da6a701c568545dCfcB03FcB875f56beddC4", "0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2", "0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db"]
//50,[["0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2",10],["0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db",40]]