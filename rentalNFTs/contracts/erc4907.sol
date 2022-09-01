// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./IERC4907.sol";

contract erc4907 is ERC721, IERC4907 {
    struct userInfo {
        address user;
        uint64 expires;
    }

    mapping(uint256 => userInfo) internal users;

    constructor(string memory name_, string memory symbol_)
        ERC721(name_, symbol_)
    {}

    function setUser(
        uint256 _tokenId,
        address _user,
        uint64 _expires
    ) public virtual {
        require(
            _isApprovedOrOwner(msg.sender, _tokenId),
            "ERROR: You do not have permissions to use this function!"
        );
        userInfo storage tenant = users[_tokenId];
        tenant.user = _user;
        tenant.expires = _expires;
        emit UpdateUser(_tokenId, _user, _expires);
    }

    function userOf(uint256 _tokenId) public view returns (address) {
        if (uint256(users[_tokenId].expires) >= block.timestamp) {
            return users[_tokenId].user;
        } else {
            return address(0);
        }
    }

    function userExpires(uint256 _tokenId) public view returns (uint256) {
        return users[_tokenId].expires;
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override
        returns (bool)
    {
        return
            interfaceId == type(IERC4907).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override {
        super._beforeTokenTransfer(from, to, tokenId);
        if (from != to && users[tokenId].user != address(0)) {
            delete users[tokenId];
            emit UpdateUser(tokenId, address(0), 0);
        }
    }
}
