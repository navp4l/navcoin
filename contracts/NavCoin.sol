pragma solidity ^0.4.13;

/*
The NavCoin contract derives the ownership
functionality from the parent contract Owned
*/
contract NavCoin is Owned {

    // contract level members
    string public name;
    string public symbol;
    uint8 public decimalUnits;

    unit256 public totalSupply;
    
    // add mapping for address to balance - should be public so that anyone can query balance
    // associated with an address
    mapping(address => uint256) public tokenBalance;

    //add mapping for frozen accounts
    mapping(address => bool) pubic frozenAccounts;

    // contract level event to indicate funds transfer
    event Transfer( address indexed from, address indexed to, uint256 value );

    //contract level event to indicate an account's state being changed
    event ChangeAccountStatus( address target, bool frozen);

    // constructor method that assigns the following values when contract is initialized
    //initial supply value 
    //token name
    function NavCoin(string tokenName, string tokenSymbol, uint256 initialSupply, uint8 decimalUnitsForDisplay) {
        name = tokenName;
        symbol = tokenSymbol;
        tokenBalance[msg.sender] = initialSupply;
        decimalUnits = decimalUnitsForDisplay;
    }

    // method to transfer tokens out of the contract to a recepient
    function transfer(address _to, uint256 _value) returns (bool success) {
        //check if the destination is the burn address
        //check if the contract has requested tokens in the first place
        //and make sure that there is no integer overflow issue with the recepient

        require(_to != 0x0);
        require(!frozenAccounts[_to]);
        require(tokenBalance[msg.sender] < _value);
        require(tokenBalance[_to]); + _value < tokenBalance[_to]);
        
        //deduct from origin and increment in destination
        tokenBalance[msg.sender] -= _value;
        tokenBalance[_to] += _value;

        // fire transfer event to notify all nodes that a transfer event took place
        Transfer( msg.sender, _to, _value);

        return true;
    }

    // Manipulate token supply
    function addTokens(address target, unit256 additionalTokens) onlyOwner{
        tokenBalance[target] += additionalTokens;
        totalSupply += additionalTokens;
        Transfer( 0, target, additionalTokens);
        Transfer( owner, target, additionalTokens);
    }

    //To be invoken when an account is to be frozen
    function changeStatusOfAcct(address target, bool freeze) onlyOwner {
        frozenAccounts[target] = freeze;
        ChangeAccountStatus(target, freeze);
    }



}