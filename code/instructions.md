INSTRUCTIONS TO USE THE KYC SMART CONTRACT

Functions in the smart contract:
    1. Add Bank
    2. Addrequest
    3. Add Customer
    4. Modify Customer
    5. Upvote Customer
    6. Downote Customer
    7. Remove Request
    8. View Customer
    9. View Bank Details
    10. Report Bank
    11. Get Bank Complaints
    12. ModifyBank
    13. Remove Bank

There are total of 13 functions in the smart contract and each function is linked to other in one away or another.

Among the functions 3 functions are exclusive to the admin.
    1. Add Bank
    2. ModifyBank
    3. Remove Bank

And remaining functions can be accessed by the valid members of the network. While the admin have the access to everyone.



Smart Contract Flow

For the network to work, we need banks in the network and the customers. While the customers will come to the banks naturally; first we need to add the banks to the network
    • Add Bank
It is better to have more than 5 banks in the network to make the blockchain more secure.

Second step will be customers coming to the bank to get approval of KYC with their details and the important documents.
    • Add Request
    • UpVote Customer
    • DownVote Customer
    • Add Customer
    • Remove Request

After getting the customer details, banks will add request while filling the details and it is stored in the smart contract. Later, all the members of the blockchain can see the data of customer and do their own verification before either upvoting or down voting the customer details.

If the upvotes are greater than downvotes, the kyc of that customer will be approved; otherwise, if one third of total banks will downvote the customer details, not only the customer kyc will be dissaporved but also the bank that filed and approved the customer details will become invalid bank and it cannot participate in the activities until the admin approves the banks’ integrity.
At the same in either of two cases, where the kyc is failed or the kyc is approved, valid banks can remove the request from request ledger.

    • Modify Customer

After the customer is added to the ledger, any valid bank can modify the customer details. But the customer username is absolute.



    • Report Bank

Any valid member of the network can report other banks if they found it is doing any type of illegal or criminal activities. Also if the reports on the bank reaches greater one third of total banks, the bank will marked as invalid bank until the admin approves the banks’ integrity. 

    • View Customers
    • View Bank Details
    • Get Complaints

Using the above functions, members of the bank can see either bank details or customer details by providing the necessary details.

Using the third function, members of the network can get the number of reports lodged on the any banks.

    • Modify Bank
    • Remove Bank

Using the modify bank, admin can make any banks valid or invalid under any circumstances. In case of bank moral integrity does not match with the network values, or under any circumstances, admin can remove the bank from the network using the last function.

NB: For the sake of readability, function names are insensitive. But this does not affect smart contract performance.
NB: In any of the cases mentioned below, the code will throw errors.
    • Requesting the bank or customer details before adding.
    • Trying to add the customer before requesting to add or with insufficient votes.
    • Adding the account that has already existed in the blockchain.
    • Requesting to add already existed kyc account.
    • Trying to mdoify non-existing customer account.




       





