Group Partners

Prateek Arora 78190197

Functionality Implemented

1) Mining, Wallet, Transaction
2) The distributed Bitcoin protocol with 100 users and distributed mining.
3) The first blockchain that has been computed is given to all the users.
4) Various Mining transaction scenarios have been implemented.

HOW TO RUN

1) Use Linux based systems
2) Then do 'mix do deps.get' to get the dependencies 
3) 'mix test' to run all the test cases

Running the simulation

1) mix escript.build
2) escript cryptocurrency

The simulation is shown in the terminal. The gist is explained below for the simulation

1) A main method calls a supervisor.
2) The supervisor is a dynamic supervisor. It spawns 100 children on request which are actors/persons/miners
3) They are initialized with their wallets. 
4) The balance is 0 in the beginning
5) We add the genesis block to the blockchain and communicate to all actors/persons/miners which are genservers
6) Then we transfer funds to them 
7) We can see the balances appearing correctly. Also their is test case for correct balances between two users
8) We further communicate to all persons to start mining.
9) We have unit test cases for mining which show mining with matching previous hashes and proof of work.
10) Once all miners have started mining, they send the response back to the main supervisor. The first one is 
added to the blockchain by the supervisor and communicated to all genservers
11) The blockchain is logged on to the screen for each user so we can see that all of them have the same blockchain
with proof of work being 00 and the blockchain does have that too.


Test cases explained

1) File keypair_test.exs

a) Test Case 1 checks the generation of public and private key for the wallet
b) Test Case 2 generates two different key pairs and checks they should have different private keys
c) Test Case 3 generates a keypair and then converts the Private key to public key and checks if the generated key was same to the private key

2) File blockchain_test.exs
The blockchain difficulty has been hardcoded as 2 for faster mining of blocks
a) Test Case 1 generates a geneis block by using the Blockchain module and then checks if the hash of the genesis block generated matches the real genesis block. 
b) The Test case 2 adds three more blocks to the blockchain. It checks if the block's previous hash is same as the value of the hash stored in current block's prev hash field
c) It also checks if the difficulty is 2 for all the blocks being generated.

3) File transaction_test.exs
a) The test case generates two pair of keypairs which are the wallets of the users that are transacting
b) It then generates 100 coins using the coinbase transaction.
c) The 100 coins are assigned to wallet1.
d) The transcation is added to the blockchain.
e) We find out balances of wallet1 and wallet2 which are 100 and 0 respectively.
f) The next transaction we do is transferring of 80 coins from wallet1 to wallet 2.
f) We again query to find the amount of coins in wallet1 and wallet2.
g) In the assertion, we find that the transaction was successful and coins have been transferred.
h) This transaction is added to the blockchain.
