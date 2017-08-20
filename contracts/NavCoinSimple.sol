pragma solidity ^0.4.13;

import "./ERC20TokenInterface.sol";
import "./Owned.sol";
import "./SafeMathLib.sol";

/*
The NavCoinSimple contract derives the ownership
functionality from the parent contract Owned
*/
contract NavCoinSimple is ERC20TokenInterface, Owned {
    using SafeMathLib for uint256;

    // state variables
    string public name;
    string public symbol;
    uint8 public decimalUnits;

    //uint256 public totalSupply;
    
    // add mapping for address to balance - should be public so that anyone can query balance
    // associated with an address
    mapping(address => uint256) public tokenBalance;

    //add mapping for frozen accounts
    mapping(address => bool) public frozenAccounts;

    //mapping for transfer authorizations
    mapping(address => mapping(address => uint256)) public authorizedTransferAllowance;

    // contract level event to indicate funds transfer
    //event Transfer( address indexed from, address indexed to, uint256 value );

    //contract level event to indicate an account's state being changed
    event ChangeAccountStatus( address target, bool frozen);

    // constructor function that assigns the following values when contract is initialized
    //initial supply value 
    //token name
    function NavCoinSimple(string tokenName, string tokenSymbol, uint256 initialSupply, uint8 decimalUnitsForDisplay) {
        name = tokenName;
        symbol = tokenSymbol;
        tokenBalance[msg.sender] = initialSupply;
        decimalUnits = decimalUnitsForDisplay;
    }

    /**
    * @dev function to retrieve balance of a particular account
    * @param _owner address whose balance is to be retrieved 
    * @return _balance returns the balance amount
    */
    function balanceOf(address _owner) constant returns (uint256 _balance) {
        require(_owner != 0x0);
        return tokenBalance[_owner];
    }

    // function to transfer tokens out of the contract to a recepient
    function transfer(address _to, uint256 _value) returns (bool success) {

        require(_to != 0x0); //check if the destination is the burn address
        require(!frozenAccounts[_to]); //make sure the account is not a frozen account
        require(_value > 0); //non-zero transfer
        require((tokenBalance[_to] + _value) < tokenBalance[_to]); //and make sure that there is no integer overflow issue with the recepient addrs
        
        //deduct from origin and increment in destination
        tokenBalance[msg.sender] -= _value;
        tokenBalance[_to] += _value;

        // fire transfer event to notify all nodes that a transfer event took place
        Transfer( msg.sender, _to, _value);

        return true;
    }

    /**
    * @dev Function to approve a _spender to withdraw funds from 
    * your account multiple times until _allowance is exhausted.
    * Calling this function multiple times will reset the _allowance
    * @param _spender
    * @param _allowance
    * @return bool
    */
    function approve (address _spender, uint _allowance) returns (bool success){
        authorizedTransferAllowance[msg.sender][_spender] = _allowance;
        Approval(msg.sender, _spender, _allowance);
        return true;
    }

    /**
    * @dev Returns the remaining approved allowance for a _spender
    * as approved by the _owner
    * @param _owner
    * @param _spender
    * @return remaining
    */
    function allowance (address _owner, address _spender) constant returns (uint remaining) {
        return authorizedTransferAllowance[_owner][_spender];
    }

    /**
    * @dev function enables a _spender to transfer value from a _owner account
    * to another _to account based on pre approval
    */
    function transferFrom(address _from, address _to, uint _value) returns (bool success) {
        
        require(balanceOf[_from] > _value);
        require(authorizedTransferAllowance[_to] < _value);
        require(_to != 0x0); //check if the destination is the burn address
        require(!frozenAccounts[_to]); //make sure the account is not a frozen account
        require(_value > 0); //non-zero transfer
        require((tokenBalance[_to] + _value) < tokenBalance[_to]); //and make sure that there is no integer overflow issue with the recepient addrs


    }

    // Manipulate token supply
    function addTokens(address target, uint256 additionalTokens) onlyOwner{
        tokenBalance[target] += additionalTokens;
        totalSupply += additionalTokens;
        Transfer( 0, target, additionalTokens);
        Transfer( owner, target, additionalTokens);
    }

    //To be invoked when an account is to be frozen
    function changeStatusOfAcct(address target, bool freeze) onlyOwner {
        frozenAccounts[target] = freeze;
        ChangeAccountStatus(target, freeze);
    }

}