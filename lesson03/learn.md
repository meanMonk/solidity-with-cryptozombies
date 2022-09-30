# Lesson 03

## Imutability of contracts.
 - After you deploy your contract to Ethereum, it's immutable, which means that it can never be modified or updated again.
 - The initial code you deploy to the contract is there to stay, permanently on blockchain. this is the one reason security is such a huge concern in solidity.
 - If there's a flaw in your contract code, there's no way for you to patch it later. You would have to tell your users to start using a different smart contract address that has the fix
 - But this is also a feature of smart contracts. The code is law. If you read the code of a smart contract and verify it, you can be sure that every time you call a function it's going to do exactly what the code says it will do. No one can later change that function and give you unexpected results.

## External Dependencies.

 - In Lesson 2, we hard-coded the CryptoKitties contract address into our DApp. But what would happen if the CryptoKitties contract had a bug and someone destroyed all the kitties?
 - It's unlikely, but if this did happen it would render our DApp completely useless — our DApp would point to a hardcoded address that no longer returned any kitties. Our zombies would be unable to feed on kitties, and we'd be unable to modify our contract to fix it.
 - For this reason, it often makes sense to have functions that will allow you to update key portions of the DApp.

## Ownable Contracts
 - setKittyContractAddress is external, so anyone can call it! That means anyone who called the function could change the address of the CryptoKitties contract, and break our app for all its users.
 - We do want the ability to update this address in our contract, but we don't want everyone to be able to update it.
 - To handle cases like this, one common practice that has emerged is to make contracts Ownable — meaning they have an owner (you) who has special privileges.

## Constructor
 - `Constructors`: constructor() is a constructor, which is an optional special function that has the same name as the contract. It will get executed only one time, when the contract is first created.

## Modifier
 - `Modifiers`: unction Modifiers: modifier onlyOwner(). Modifiers are kind of half-functions that are used to modify other functions, usually to check some requirements prior to execution. In this case, onlyOwner can be used to limit access so only the owner of the contract can run this function. 


# Gas — the fuel Ethereum DApps run on
 - In Solidity, your users have to pay every time they execute a function on your DApp using a currency called gas. Users buy gas with Ether (the currency on Ethereum), so your users have to spend ETH in order to execute functions on your DApp.
 - How much gas is required to execute a function depends on how complex that function's logic is. Each individual operation has a gas cost based roughly on how much computing resources will be required to perform that operation (e.g. writing to storage is much more expensive than adding two integers). The total gas cost of your function is the sum of the gas costs of all its individual operations.
 - Because running functions costs real money for your users, code optimization is much more important in Ethereum than in other programming languages. If your code is sloppy, your users are going to have to pay a premium to execute your functions — and this could add up to millions of dollars in unnecessary fees across thousands of users.

## Why is gas necessory ?
 - Ethereum is like a big, slow, but extremely secure computer. When you execute a function, every single node on the network needs to run that same function to verify its output — thousands of nodes verifying every function execution is what makes Ethereum decentralized, and its data immutable and censorship-resistant.
 - The creators of Ethereum wanted to make sure someone couldn't clog up the network with an infinite loop, or hog all the network resources with really intensive computations. So they made it so transactions aren't free, and users have to pay for computation time as well as storage

## Struct packing to save gas
 - Normally there's no benefit to using these sub-types because Solidity reserves 256 bits of storage regardless of the uint size. For example, using uint8 instead of uint (uint256) won't save you any gas.
 - ** But there's an exception to this: inside structs.
 - If you have multiple uints inside a struct, using a smaller-sized uint when possible will allow Solidity to pack these variables together to take up less storage. 
 - For example:
```
struct NormalStruct {
  uint a;
  uint b;
  uint c;
}

struct MiniMe {
  uint32 a;
  uint32 b;
  uint c;
}
// `mini` will cost less gas than `normal` because of struct packing
NormalStruct normal = NormalStruct(10, 20, 30);
MiniMe mini = MiniMe(10, 20, 30); 
```
 - For this reason, inside a struct you'll want to use the smallest integer sub-types you can get away with.
 - You'll also want to cluster identical data types together (i.e. put them next to each other in the struct) so that Solidity can minimize the required storage space. For example, a struct with fields `uint c; uint32 a; uint32 b;` will cost less gas than a struct with fields `uint32 a; uint c; uint32 b;` because the uint32 fields are clustered together.

## Time Units
 - Solidity provides some native units for dealing with time.
 - The variable `now` will return the current unix timestamp of the latest block (the number of seconds that have passed since January 1st 1970). The unix time as I write this is 1515527488
>>> Note: Unix time is traditionally stored in a 32-bit number. This will lead to the "Year 2038" problem, when 32-bit unix timestamps will overflow and break a lot of legacy systems. So if we wanted our DApp to keep running 20 years from now, we could use a 64-bit number instead — but our users would have to spend more gas to use our DApp in the meantime. Design decisions!

 - Solidity also contains the time units seconds, minutes, hours, days, weeks and years. These will convert to a uint of the number of seconds in that length of time. So 1 minutes is 60, 1 hours is 3600 (60 seconds x 60 minutes), 1 days is 86400 (24 hours x 60 minutes x 60 seconds), etc.
 - Here's an example of how these time units can be useful:

```
uint lastUpdated;

// Set `lastUpdated` to `now`
function updateTimestamp() public {
  lastUpdated = now;
}

// Will return `true` if 5 minutes have passed since `updateTimestamp` was 
// called, `false` if 5 minutes have not passed
function fiveMinutesHavePassed() public view returns (bool) {
  return (now >= (lastUpdated + 5 minutes));
}
```

## Public Functions & Security
## More on Function Modifiers
### Function modifiers with arguments

Previously we looked at the simple example of onlyOwner. But function modifiers can also take arguments. For example:
```
// A mapping to store a user's age:
mapping (uint => uint) public age;

// Modifier that requires this user to be older than a certain age:
modifier olderThan(uint _age, uint _userId) {
  require(age[_userId] >= _age);
  _;
}

// Must be older than 16 to drive a car (in the US, at least).
// We can call the `olderThan` modifier with arguments like so:
function driveCar(uint _userId) public olderThan(16, _userId) {
  // Some function logic
}

```
You can see here that the olderThan modifier takes arguments just like a function does. And that the driveCar function passes its arguments to the modifier.

Let's try making our own modifier that uses the zombie level property to restrict access to special abilities.

## CallData
 - Note: `calldata` is somehow similar to memory, but it's only available to external functions.

## Saving Gas With 'View' Functions
 - `View` functions don't cost gas
 - view functions don't cost any gas when they're called externally by a user.
 - This is because view functions don't actually change anything on the blockchain – they only read the data. So marking a function with view tells web3.js that it only needs to query your local Ethereum node to run the function, and it doesn't actually have to create a transaction on the blockchain (which would need to be run on every single node, and cost gas).
 - We'll cover setting up web3.js with your own node later. But for now the big takeaway is that you can optimize your DApp's gas usage for your users by using read-only external view functions wherever possible.

>>> 
Note: If a view function is called internally from another function in the same contract that is not a view function, it will still cost gas. This is because the other function creates a transaction on Ethereum, and will still need to be verified from every node. So view functions are only free when they're called externally.


## Storage is Expensive
  - One of the more expensive operations in Solidity is using storage — particularly writes.

  - This is because every time you write or change a piece of data, it’s written permanently to the blockchain. Forever! Thousands of nodes across the world need to store that data on their hard drives, and this amount of data keeps growing over time as the blockchain grows. So there's a cost to doing that.
  - In order to keep costs down, you want to avoid writing data to storage except when absolutely necessary. Sometimes this involves seemingly inefficient programming logic — like rebuilding an array in memory every time a function is called instead of simply saving that array in a variable for quick lookups.
  - In most programming languages, looping over large data sets is expensive. But in Solidity, this is way cheaper than using storage if it's in an external view function, since view functions don't cost your users any gas. (And gas costs your users real money!).
  - We'll go over for loops in the next chapter, but first, let's go over how to declare arrays in memory.

>>> Note: memory arrays must be created with a length argument (in this example, 3). They currently cannot be resized like storage arrays can with array.push(), although this may be changed in a future version of Solidity.


## For Loops