<!-- Mapping And Address -->

## Addresses
 - The Ethereum blockchain is made up of accounts, which you can think of like bank accounts. An account has a balance of Ether (the currency used on the Ethereum blockchain), and you can send and receive Ether payments to other accounts, just like your bank account can wire transfer money to other bank accounts.
 - Each account has an address, which you can think of like a bank account number. It's a unique identifier that points to that account,
 - We'll get into the nitty gritty of addresses in a later lesson, but for now you only need to understand that an address is owned by a specific user (or a smart contract).

  

## Mapping 
 - Mapping is another way of storing organized data in solidity
 - difining mapping looks like this.
 - `mapping (address => uint) public accountBalance;`
 - `mapping (uint => string) userIdName;@ `
 
 
## msg.sender
  - In solidity, there are certain global variables that are available to all functions. One of these
  - is msg.sender, which refers to the address of the person (or smart contract)  who called the current function.

  >>> Note: In solidity, Function executation always needs to start with an external caller. A contract will just sit on the blockchain doing nothing until someone calls one of it's functions. so there will always be a `msg.sender`.

## Require
  - `require` makes it so that the function will throw an error and stop executing if some condition is not `true`

NOTE :
  - (Side note: Solidity doesn't have native string comparison, so we compare their keccak256 hashes to see if the strings are equal)

## Inheritance
  - Sometime it makes sense to split your code logic across multiple contracts to organize the code.
  - One feature of Solidity that makes this more manageable is contract inheritance:
```
contract Doge {
  function catchphrase() public returns (string memory) {
    return "So Wow CryptoDoge";
  }
}

contract BabyDoge is Doge {
  function anotherCatchphrase() public returns (string memory) {
    return "Such Moon BabyDoge";
  }
}
```
  - BabyDoge inherits from Doge. That means if you compile and deploy BabyDoge, it will have access to both catchphrase() and anotherCatchphrase() (and any other public functions we may define on Doge).


## Import

`import "./path-to-file/contract.sol"`


## Data Location in Solidity.

### Storage Vs Memory

 - `Storage` refers to variables store permanently on the blockchain
 - `Memory` variables are temporary, or external function call to your contract. like RAM.
 - Most of the time you don't need to use this because solidity handles this by default
 - State Variables (variable declared outside the function) are by default storage and written permanantly on blockchain
 - while var declared inside the functions are `Memory` and will disappear when the fuction call ends.


## Public vs Private vs Internal vs External

## Internal & External 
 - In addition to `public` and `private`, Solidity has two more types of visibility for functions: `internal` and `external`.

## Interacting with other contracts.

For our contract to talk to another contract on the blockchain that we don't own, first we need to define an interface.

Let's look at a simple example. Say there was a contract on the blockchain that looked like this:
```
contract LuckyNumber {
  mapping(address => uint) numbers;

  function setNum(uint _num) public {
    numbers[msg.sender] = _num;
  }

  function getNum(address _myAddress) public view returns (uint) {
    return numbers[_myAddress];
  }
}
```

This would be a simple contract where anyone could store their lucky number, and it will be associated with their Ethereum address. Then anyone else could look up that person's lucky number using their address.

Now let's say we had an external contract that wanted to read the data in this contract using the getNum function.

### Defining interface
First we'd have to define an interface of the LuckyNumber contract:
```
contract NumberInterface {
  function getNum(address _myAddress) public view returns (uint);
}
```
Notice that this looks like defining a contract, with a few differences. For one, we're only declaring the functions we want to interact with — in this case getNum — and we don't mention any of the other functions or state variables.

Secondly, we're not defining the function bodies. Instead of curly braces ({ and }), we're simply ending the function declaration with a semi-colon (;).

So it kind of looks like a contract skeleton. This is how the compiler knows it's an interface.

By including this interface in our dapp's code our contract knows what the other contract's functions look like, how to call them, and what sort of response to expect.


### Using interface
We can use it in a contract as follows:
```
contract MyContract {
  address NumberInterfaceAddress = 0xab38... 
  // ^ The address of the FavoriteNumber contract on Ethereum
  NumberInterface numberContract = NumberInterface(NumberInterfaceAddress);
  // Now `numberContract` is pointing to the other contract

  function someFunction() public {
    // Now we can call `getNum` from that contract:
    uint num = numberContract.getNum(msg.sender);
    // ...and do something with `num` here
  }
}
```

In this way, your contract can interact with any other contract on the Ethereum blockchain, as long they expose those functions as public or external.

## Handling multiple return values.

This getKitty function is the first example we've seen that returns multiple values. Let's look at how to handle them:

```
function multipleReturns() internal returns(uint a, uint b, uint c) {
  return (1, 2, 3);
}

function processMultipleReturns() external {
  uint a;
  uint b;
  uint c;
  // This is how you do multiple assignment:
  (a, b, c) = multipleReturns();
}

// Or if we only cared about one of the values:
function getLastReturnValue() external {
  uint c;
  // We can just leave the other fields blank:
  (,,c) = multipleReturns();
}
```


## If statements
  - If statements in Solidity look just like javascript:
```
function eatBLT(string memory sandwich) public {
  // Remember with strings, we have to compare their keccak256 hashes
  // to check equality
  if (keccak256(abi.encodePacked(sandwich)) == keccak256(abi.encodePacked("BLT"))) {
    eat();
  }
}

```