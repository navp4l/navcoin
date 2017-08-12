pragma solidity ^0.4.13;

contract NavCoin {

    // contract level members
    string public name;
    string public symbol;
    uint8 public decimalUnits;
    
    // add mapping for address to balance - should be public so that anyone can query balance
    // associated with an address
    mapping(address => uint256) public tokenBalance;

    // contract level events to indicate funds transfer
    event Transfer( address indexed from, address indexed to, uint256 value );

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

        if( _to == 0x0 || tokenBalance[msg.sender] < _value || tokenBalance[_to] + _value < tokenBalance[_to] ) throw;

        //deduct from origin and increment in destination
        tokenBalance[msg.sender] -= _value;
        tokenBalance[_to] += _value;

        // fire transfer event to notify all nodes that a transfer event took place
        Transfer( msg.sender, _to, _value);
    }
}