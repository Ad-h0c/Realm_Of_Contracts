//SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.22 <0.9.0;

contract Access {
    string BankName;
    address admin;
    uint8 TotalBanks;
    uint8 upVotesCount = 0;
    uint8 downVotesCount = 0;

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(
            msg.sender == admin,
            "Error: Only Admin can get access through this channels"
        );
        _;
    }
}
