pragma solidity ^0.4.15;

contract NavCoin {
    
    // add mapping for address to balance - should be public so that anyone can query balance
    // associated with an address
    mapping(address => uint256) public tokenBalance;

    // constructor method that assigns initial supply value when contract is initialized
    function NavCoin(unit256 initialSupply) {
        tokenBalance[msg.sender] = initialSupply;
    }

    // method to transfer tokens out of the contract to a recepient
    function transfer(address _to, uint256 _value) returns (bool success) {
        //check if the destination is the burn address
        //check if the contract has requested tokens in the first place
        //and make sure that there is no integer overflow issue with the recepient

        if( _to == 0x0 ) throw;
        if( tokenBalance[msg.sender] < _value )  throw;
        if( tokenBalance[_to] + _value < tokenBalance[_to] ) throw;

        //deduct from origin and increment in destination
        tokenBalance[msg.sender] -= _value;
        tokenBalance[_to] += _value;

        // fire transfer event
        Transfer( msg.sender, _to, _value);
    }







}