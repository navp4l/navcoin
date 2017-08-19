pragma solidity ^0.4.13;

/**
* @title Library that makes arithmetic operations on 
* uint256 safe
*/

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
	function subtract (uint256 _a, unit256 _b) internal constant returns (uint256) {
		require(_a >= _b);
		uint256 _c = _a - _b;
		return _c;
	}

}
