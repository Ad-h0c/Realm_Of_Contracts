# Rental NFTs[EIP-4907]


Some NFTs have certain utilities. For example, virtual land can be “used” to build scenes, and NFTs representing game assets can be “used” in-game. In some cases, the owner and user may not always be the same. There may be an owner of the NFT that rents it out to a “user”. The actions that a “user” should be able to take with an NFT would be different from the “owner” (for instance, “users” usually shouldn’t be able to sell ownership of the NFT).  In these situations, it makes sense to have separate roles that identify whether an address represents an “owner” or a “user” and manage permissions to perform actions accordingly.

Some projects already use this design scheme under different names such as “operator” or “controller” but as it becomes more and more prevalent, we need a unified standard to facilitate collaboration amongst all applications.

Furthermore, applications of this model (such as renting) often demand that user addresses have only temporary access to using the NFT. Normally, this means the owner needs to submit two on-chain transactions, one to list a new address as the new user role at the start of the duration and one to reclaim the user role at the end. This is inefficient in both labor and gas and so an “expires” function is introduced that would facilitate the automatic end of a usage term without the need of a second transaction.
