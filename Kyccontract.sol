//SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.22 <0.9.0;
import "./Access.sol"; //Importing the external contract Access

contract Kyccontract is Access {
    struct Customer {
        //The customer struct
        string userName;
        string customerData;
        bool kycStatus;
        uint8 downVotes;
        uint8 upVotes;
        address bank;
    }
    struct Bank {
        //The bank struct
        string bankName;
        address bankAddress;
        uint8 complaintsReported;
        uint8 KYC_count;
        bool isAllowedToVote;
        string regNumber;
    }

    struct kycRequest {
        //Kyc request struct
        string userName;
        address bankAddress;
        string customerData;
    }

    //Using mappings on above structs.
    mapping(string => Customer) customers;
    mapping(address => Bank) banks;
    mapping(string => kycRequest) requests;

    modifier AB() {
        // Modifier to check if it is either admin or valid bank
        require(
            msg.sender == admin || banks[msg.sender].isAllowedToVote == true,
            "Error: ERROR: Only or admins valid banks can use the following function!"
        );
        _;
    }

    //user can provide data and request to get verify
    function Addrequest(string memory _userName, string memory _customerData)
        public
        AB
    {
        require(
            customers[_userName].bank == address(0),
            "The account is already existed"
        );
        requests[_userName].userName = _userName;
        requests[_userName].customerData = _customerData;
        requests[_userName].bankAddress = msg.sender;
    }

    //valid banks can add the customer to the server whose details are verified.
    function addCustomer(string memory _userName, string memory _customerData)
        public
        AB
    {
        require(
            customers[_userName].bank == address(0),
            "ERROR: The account is already existed, user modify customer to either edit or delete the account!"
        );
        require(
            requests[_userName].bankAddress != address(0),
            "ERROR: Banks should add KYC request before adding the customer!"
        );
        if (upVotesCount > downVotesCount) {
            customers[_userName].kycStatus = true;
            customers[_userName].userName = _userName;
            customers[_userName].customerData = _customerData;
            customers[_userName].bank = msg.sender;
        } else if (downVotesCount > (TotalBanks / 3)) {
            customers[_userName].kycStatus = false;
            if (downVotesCount >= TotalBanks / 2) {
                //Here, customers[_userName].bank is the address of the bank that approved the downvoted customer.
                banks[customers[_userName].bank].isAllowedToVote = false;
            }
        }
    }

    //Once the customer added to the blockchain, banks can remove the customer from the requestlist.
    function removeRequest(string memory _userName) public AB {
        require(
            downVotesCount > (TotalBanks / 3) ||
                customers[_userName].bank != address(0),
            "Either downvotes are unsufficient or the customer is not in the database"
        );
        delete requests[_userName];
    }

    //This function is helpful to view the customers inside the blockchain.
    function viewCustomer(string memory _userName)
        public
        view
        returns (
            string memory,
            string memory,
            address,
            bool,
            uint8,
            uint8
        )
    {
        require(
            customers[_userName].bank != address(0),
            "The account isn't existed in the database"
        );
        //customer details needs to be inside the database to view them.
        return (
            customers[_userName].userName,
            customers[_userName].customerData,
            customers[_userName].bank,
            customers[_userName].kycStatus,
            customers[_userName].downVotes,
            customers[_userName].upVotes
        );
    }

    //valid banks can upvote the customer and their data's authenticity
    function upvoteCustomers(string memory _userName) public AB {
        upVotesCount = customers[_userName].upVotes += 1;
    }

    //Whitlisted banks can downvote the customer and their data's authenticity
    function downvoteCustomers(string memory _userName) public AB {
        downVotesCount = customers[_userName].downVotes -= 1;
    }

    //valid Banks can modify the customers through this function.
    function modifyCustomer(
        string memory _userName,
        string memory _newcustomerData
    ) public AB {
        require(
            customers[_userName].bank != address(0),
            "The account isnt existed in the database"
        );
        //Customer details needs to be inside the servers to modify them.
        customers[_userName].customerData = _newcustomerData;
        delete requests[_userName];
        customers[_userName].upVotes = 0;
        customers[_userName].downVotes = 0;
    }

    //This function helps us to retrive the complaints lodged on the particular bank throught its unique bank address.
    function getBankComplaints(address _bankAddress)
        public
        view
        returns (uint8)
    {
        return banks[_bankAddress].complaintsReported;
    }

    //using this function, one can see the bank details.
    function viewbankDetails(address _bankAddress)
        public
        view
        returns (
            string memory,
            address,
            uint8,
            uint8,
            bool,
            string memory
        )
    {
        return (
            banks[_bankAddress].bankName,
            banks[_bankAddress].bankAddress,
            banks[_bankAddress].complaintsReported,
            banks[_bankAddress].KYC_count,
            banks[_bankAddress].isAllowedToVote,
            banks[_bankAddress].regNumber
        );
    }

    //valid banks can give complain the other banks.
    function reportBank(address _bankAddress) public AB {
        uint8 reportCount = banks[_bankAddress].complaintsReported += 1;
        if (reportCount > (TotalBanks / 3)) {
            banks[_bankAddress].isAllowedToVote = false;
        }
    }

    //Only Admin can add the bank.
    function addBank(
        string memory _bankName,
        address _bankAddress,
        string memory _regNumber
    ) public onlyAdmin {
        banks[_bankAddress].bankName = _bankName;
        banks[_bankAddress].bankAddress = _bankAddress;
        banks[_bankAddress].complaintsReported = 0;
        banks[_bankAddress].KYC_count = 0;
        banks[_bankAddress].isAllowedToVote = true;
        banks[_bankAddress].regNumber = _regNumber;
        TotalBanks += 1;
    }

    //Admin can give or take the right to vote other banks.
    function modifyBank(address _bankAddress, bool _isAllowedToVote)
        public
        onlyAdmin
    {
        banks[_bankAddress].isAllowedToVote = _isAllowedToVote;
    }

    //Using this function admin can remove the bank from the blockchain.
    function removeBank(address _bankAddress) public onlyAdmin {
        delete banks[_bankAddress];
        TotalBanks -= 1;
    }
}
