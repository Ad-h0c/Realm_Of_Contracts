//SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Vworld is ERC721 {
  uint224 public cost = 1 ether;
  uint16 public constant maxSupply = 3;
  uint16 public totalSupply = 0;

  struct area {
    string name;
        address owner;
        uint128 posX;
        uint128 posY;
        uint128 sizeX;
        uint128 sizeY;
  }

  area[] public areas;
  constructor(
        string memory _name,
        string memory _symbol,
        uint256 _cost
    ) ERC721(_name, _symbol) {
        cost = uint224(_cost);
        areas.push(
          area("area1", address(0), 0, 50, 50, 50)
        );
        areas.push(
          area("area2", address(0), 50, 50, 50, 50)
        );
        areas.push(
          area("area3", address(0), 0, 0, 50, 100)
        );
    }

    function mint(uint _id) public payable {
        uint256 supply = totalSupply;
        require(supply <= maxSupply);
        require(areas[_id - 1].owner == address(0));
        require(msg.value >= cost);

        // NOTE: tokenID always starts from 1, but the array starts from 0
        areas[_id - 1].owner = msg.sender;
        totalSupply += 1;

        _safeMint(msg.sender, _id);
    }

      function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public override {
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "ERC721: transfer caller is not owner nor approved"
        );

        // Update Building ownership
        areas[tokenId - 1].owner = to;

        _transfer(from, to, tokenId);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public override {
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "ERC721: transfer caller is not owner nor approved"
        );

        // Update Building ownership
        areas[tokenId - 1].owner = to;

        _safeTransfer(from, to, tokenId, _data);
    }

    // Public View Functions
    function getAreas() public view returns (area[] memory) {
        return areas;
    }

    function getArea(uint256 _id) public view returns (area memory) {
        return areas[_id - 1];
    }


}