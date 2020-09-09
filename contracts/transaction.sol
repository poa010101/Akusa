pragma solidity ^0.5.0;

contract transaction {
  mapping (uint256 => string ) public transactions;

  function set(uint256 tid, string memory s) public {
    transactions[tid] = s;
  }

  function get(uint256 tid) public view returns (string memory) {
    return transactions[tid];
  }
}
