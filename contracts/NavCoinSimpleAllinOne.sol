pragma solidity ^0.4.13;

contract Owned {
    address public owner; //public member to hold to address of the contract owner

    //initialize contract with sender as the owner
    function Owned() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner); //requires that the executer be the owner of the contract
        _;
    }

    //Treansfer ownership can only be executed by the contract owner
    function transferOwnership(address newOwner) onlyOwner {
        owner = newOwner;
    }
}

library SafeMathLib{

	/**
	* @dev Add two uint256 values and return the sum after asserting that the
	* sum is greater than or equal to each of the input values
	* @param _a first input
	* @param _b second input
	* @return _c sum of two input values
	*/
	function add (uint256 _a, uint256 _b) internal constant returns(uint256) {
		uint256 _c = _a + _b;
		assert(_c >= _a);
		assert(_c >= _b);
		return _c;
	}

	/**
	* @dev Subtract two uint256 values after asserting that _a is greater than or equal to _b and return the difference.
	* @param _a first input
	* @param _b second input
	* @return _c difference of two input values
	*/
	function subtract (uint256 _a, uint256 _b) internal constant returns (uint256) {
		require(_a >= _b);
		uint256 _c = _a - _b;
		return _c;
	}

}

contract ERC20TokenInterface {
    uint public totalSupply;
    function balanceOf(address _owner) constant returns (uint balance);
    function transfer(address _to, uint _value) returns (bool success);
    function transferFrom(address _from, address _to, uint _value)
        returns (bool success);
    function approve(address _spender, uint _value) returns (bool success);
    function allowance(address _owner, address _spender) constant
        returns (uint remaining);
    event Transfer(address indexed _from, address indexed _to, uint _value);
    event Approval(address indexed _owner, address indexed _spender,
        uint _value);
}


/*
The NavCoinSimple contract derives the ownership
functionality from the parent contract Owned
*/
contract NavCoinSimpleAllinOne is ERC20TokenInterface, Owned {
    using SafeMathLib for uint256;

    // state variables
    string public name;
    string public symbol;
    uint8 public decimalUnits;

    uint256 public totalSupply;
    
    // add mapping for address to balance - should be public so that anyone can query balance
    // associated with an address
    mapping(address => uint256) public tokenBalance;

    //add mapping for frozen accounts
    mapping(address => bool) public frozenAccounts;

    // contract level event to indicate funds transfer
    event Transfer( address indexed from, address indexed to, uint256 value );

    //contract level event to indicate an account's state being changed
    event ChangeAccountStatus( address target, bool frozen);

    // constructor method that assigns the following values when contract is initialized
    //initial supply value 
    //token name
    function NavCoinSimpleAllinOne(string tokenName, string tokenSymbol, uint256 initialSupply, uint8 decimalUnitsForDisplay) {
        name = tokenName;
        symbol = tokenSymbol;
        tokenBalance[msg.sender] = initialSupply;
        decimalUnits = decimalUnitsForDisplay;
    }

    // method to transfer tokens out of the contract to a recepient
    function transfer(address _to, uint256 _value) returns (bool success) {
        //check if the destination is the burn address
        //make sure the account is not a frozen account
        //check if the contract has requested tokens in the first place
        //and make sure that there is no integer overflow issue with the recepient

        require(_to != 0x0);
        require(!frozenAccounts[_to]);
        require(tokenBalance[msg.sender] < _value);
        require((tokenBalance[_to] + _value) < tokenBalance[_to]);
        
        //deduct from origin and increment in destination
        tokenBalance[msg.sender] -= _value;
        tokenBalance[_to] += _value;

        // fire transfer event to notify all nodes that a transfer event took place
        Transfer( msg.sender, _to, _value);

        return true;
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