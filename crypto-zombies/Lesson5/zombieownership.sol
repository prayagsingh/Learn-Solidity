pragma solidity ^0.8.5;

import "./zombieattack.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

/// TODO: Replace this with natspec descriptions
/// @title A contract that manages transfering zombie ownership
/// @author Prayag Singh
/// @dev Compliant with OpenZeppelin's implementation of the ERC721 spec draft
contract ZombieOwnership is ZombieAttack, ERC721 {

  using SafeMath for uint256;

  mapping (uint => address) zombieApprovals;

  // Initialize ERC721
  constructor() ERC721("CryptoZombies", "CZ") {}

  /** 
  Base functions can be overridden by inheriting contracts to change their behavior if 
  they are marked as `virtual`. The overriding function must then use the `override` keyword 
  in the function header. The overriding function may only change the visibility of the 
  overridden function from `external` to `public`. The mutability may be changed to a more 
  strict one following the order: `nonpayable` can be overridden by `view` and `pure`. `view` 
  can be overridden by `pure`. `payable` is an exception and cannot be changed to any other mutability.
  */
  function balanceOf(address _owner) public override view returns (uint256) {
    return ownerZombieCount[_owner];
  }

  function ownerOf(uint256 _tokenId) public override view returns (address) {
    return zombieToOwner[_tokenId];
  }

  function _transfer(address _from, address _to, uint256 _tokenId) internal override{
    ownerZombieCount[_to] = ownerZombieCount[_to].add(1);
    ownerZombieCount[msg.sender] = ownerZombieCount[msg.sender].sub(1);
    zombieToOwner[_tokenId] = _to;
    emit Transfer(_from, _to, _tokenId);
  }

  function transferFrom(address _from, address _to, uint256 _tokenId) public override {
    require (zombieToOwner[_tokenId] == msg.sender || zombieApprovals[_tokenId] == msg.sender);
    _transfer(_from, _to, _tokenId);
  }

  function approve(address _approved, uint256 _tokenId) public override onlyOwnerOf(_tokenId) {
    zombieApprovals[_tokenId] = _approved;
    emit Approval(msg.sender, _approved, _tokenId);
  }

}
