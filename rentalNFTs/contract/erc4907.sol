// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./IERC4907.sol";

contract erc4907 is ERC721, IERC4907 {

    /// Logged when the user of an NFT is changed or expires is changed
    /// @notice Emitted when the `user` of an NFT or the `expires` of the `user` is changed
    /// The zero address for user indicates that there is no user address
    
    struct userInfo {
        address user;
        uint64 expires;
    }

    mapping(uint256 => userInfo) internal users;

    constructor(string memory name_, string memory symbol_)
        ERC721(name_, symbol_)
    {}

    /// @notice set the user and expires of an NFT
    /// @dev The zero address indicates there is no user
    /// Throws if `tokenId` is not valid NFT
    /// @param user  The new user of the NFT
    /// @param expires  UNIX timestamp, The new user could use the NFT before expires

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


    /// @notice Get the user address of an NFT
    /// @dev The zero address indicates that there is no user or the user is expired
    /// @param tokenId The NFT to get the user address for
    /// @return The user address for this NFT

    function userOf(uint256 _tokenId) public view returns (address) {
        if (uint256(users[_tokenId].expires) >= block.timestamp) {
            return users[_tokenId].user;
        } else {
            return address(0);
        }
    }


    /// @notice Get the user expires of an NFT
    /// @dev The zero value indicates that there is no user
    /// @param tokenId The NFT to get the user expires for
    /// @return The user expires for this NFT

    function userExpires(uint256 _tokenId) public view returns (uint256) {
        return users[_tokenId].expires;
    }


    /// @dev See {IERC165-supportsInterface}.
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC4907).interfaceId || super.supportsInterface(interfaceId);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override{
        super._beforeTokenTransfer(from, to, tokenId);

        if (from != to && _users[tokenId].user != address(0)) {
            delete _users[tokenId];
            emit UpdateUser(tokenId, address(0), 0);
        }
}
