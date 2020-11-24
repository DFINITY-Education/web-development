# Module 2: Open Auction Platform on the Internet Computer

In this Module, you will implement an auction platform, similar to an open version of eBay, as a web application. 



*[Insert photo of rudimentary front-end view]*

## Your Task

We have provided you with an incomplete base canister and rudimentary front end - your job is to implement the necessary methods to get the application functioning correctly.

### Code Understanding

#### `Balances.mo`

The `Balances.mo` file creates a `Balances` actor that is responsible for maintaining the running tally of balances for every user in the application. *Access control* - the process of authenticating users to ensure that they have permission to run a certain application -  is essential to our implementation of `Balances`. At a high level, we only want the canister who initially called the constructor of `Balances` to be able to modify the balances inside.

Motoko and the IC enable access control by allowing functions to record the canisters that called them. The `shared` keyword declares that our `Balances` constructor [can be called remotely by other canisters](https://sdk.dfinity.org/docs/language-guide/sharing.html#_the_shared_keyword). `msg` is an optional parameter that we included, which, when combined with `shared`, takes on the value of a record field storing the id of the canister that called the constructor. We can access this id, and store it in our own variable called `owner`, with the line:

```
let owner = msg.caller;
```

In this case, `msg` and `owner` are both variable names we choose - there's nothing special about these specific names. It's common practice, however, to use this naming convention. See [this post in the Motoko SDK](https://sdk.dfinity.org/docs/language-guide/caller-id.html) for a more in-depth walkthrough of access control and use of the `shared(msg)` paradigm.

What's the end result? We now hold the id of the canister that installed the `Balances` actor stored in our `owner` variable. In the subsequent functions, we can check that the caller of that function is the same `owner` who established the `Balances` actor, ensuring proper access control.

At the top of `balances` we import two types from out `Types.mo` file: a `UserId` and a `Result`. If you take a brief look at `Types.mo`, you'll see that a `UserId` type is just a `Principal` address, and a `Result` type is just a wrapper to enable `Error` return values. We also create `userIdToBalance`, which maps `UserId`s to their corresponding  balances.

Let's begin by reviewing the last method in `Balances`. `deposit` accepts a `user` and an `amount` and increments that user's balance by the specified amount. The complication, however, is that we only want the canister that controls this `Balances` actor (think of them as an impartial "banker") to be able to increment balances. We accomplish this with the line: 

```
assert (owner == msg.caller);
```

In this case, `owner` is the stored value that we initially assigned to the ID of the canister that called the `Balances` constructor, and `caller` is the id of the canister who called this `deposit` method (as evidenced by `shared {caller}` in the signature of `deposit`). We use the `Assert` to check that the canister calling this `deposit` method is, in fact, the `owner` of the `Balances` canister; if not, the `Assert` will fail and prevent the balance from being updated.

Next, let's take a look at `transfer`, which transfers an `_amount` to the balance held at the address of `to` from the balance stored at the address of `from`. More specifically, we check if the `from` user has enough money to transfer the specified `_amount`, and, if so, we transfer the money by modifying the corresponding values in the `userIdBalance` hash map. Note that we have two similar methods to access the balance of a user: `getBalance` and `_getBalance`. The implementation details aren't important, but while both accomplish the same goal, `getBalance` is our public-facing method, while `_getBalance` is for method calls within the `Balances` canister itself. 

#### `App.mo` 

The auction app itself it relatively straightforward: we maintain individual `Auction`s, which have various attributes that we want to keep track of (see `Types.mo` for the exact list) and the actual `Item` that is being auctioned off. We store our auctions in the `auctions` lists, which maps an `AuctionId` to an `Auction` type, which contains all relevant attributes of the given auction.

`auctionItem` is a method that creates a new auction given a `caller` (the owner of the auction), a `name` (the item name), a `description` of the item, a `url` to view the location of the item (for frontend purposes), and a `startingBid`. 

`makeBid` is a method that takes a `bidder`, `auctionID`, and `amount` and updates an an auction's `highestBidder` and `highestBid` fields, simulating a person making a new bid on an auction. All other functions in `App.mo` are just helpers used in these main two functions.

#### `Governor.mo`

Our `Governor` canister manages proposed upgrades to our application. See the [Autonomous Canisters](/module-1.md#Autonomous-Canisters) section in Module 1 for a more in-depth discussion of this. 

####  `Main.mo` 

`main.mo` has one function, `setup`, which calls the constructors of the relevant canisters needed to create the entire application - namely, we need to establish a `Balances` canister to store balances, an `App` canister to control the actual process of creating and managing auctions,  a `Governor` to control the governance structure for automated upgrades, and a `balancesGov` to ...

### Specification

**Task:** Complete the implementation of the `auctionItem` and `makeBid` methods in `App.mo`.

**`auctionItem`** creates a new `Auction` and adds it to the `auctions` list

* Use the `name`, `description`, and `url` parameters are used to create a new `Item` (by calling the `makeItem` helper function defined below).
* Use this `item` to create a new auction, using the `makeAuction` helper, and finally add this auction to our `auctions` hash map  using a unique id .
  * Note that we keep a global variable `auctionCounter` to derive a unique auction id. Consider how you might need to modify/update `auctionCounter` to ensure that it provides a unique id for each new `Auction`.

**`makeBid`**

* Notice that we return a `Result` type with this method. We don't normally care about the return value of `makeBid` because the side effect - namely how we change the state of `auctions` - is the main purpose of the method. However, if the user enters an invalid receipt, we want to keep track of the error that results, which our `Result` type allows us to do. See `Types.mo` for the implementation details.
  * If the user enters a valid bid, once you have correctly done the necessary steps to process the bid you can just return `#ok()` (which indicated that the method ran with no error)
  * If the user enters an invalid bid, you must return the corresponding error variant defined in `Error` of `Types.mo`. See `Balances.mo` for a few examples of how we return errors. 
* You must first check that the `bidder` has enough money in their balance to make the specified bid. If not, return the `#insufficientBalance` error (defined in `Types.mo`) with `#err(#insufficientBalance`)`. 
* You must also retrieve the auction stored at `auctionId`. If there is no auction located at this `auctionId`, then return `#err(#auctionNotFound)`.
* Finally, check that the new bid amount is greater than the auction's current bid. If it is, then update the corresponding `Auction` accordingly. If not, return `#err(#belowMinimumBid)`.
  * You will likely find the `setNewBidder` helper that we've defined useful in updating the `Auction`.

### Testing

Take a look at the [Developer Quick Start Guide](https://sdk.dfinity.org/docs/quickstart/quickstart.html) if you'd like a quick refresher on how to run programs on a locally-deployed IC network. 

Follow these steps to deploy your canisters and launch the front end. If you run into any issues, reference the **Quick Start Guide**, linked above,  for a more in-depth walkthrough.

1.  Ensure that your dfx version matches the version shown in the `dfx.json` file by running the following command:

   ```
   dfx --version
   ```

   You should see something along the lines of:

   ```
   dfx 0.6.14
   ```

   If your dfx version doesn't match that of the `dfx.json` file, see the [this guide](https://sdk.dfinity.org/docs/developers-guide/install-upgrade-remove.html#install-version) for help in changing it. 

2. Open a second terminal window (so you can start and view network operations without conflicting with the management of your project) and navigate to the same `\web-development` directory.

   In this new window, run:

   ```
   dfx start
   ```

3. Navigate back to your main terminal window (also in the `\web-development` directory) and ensure that you have `node` modules available by running:

   ```
   npm install
   ```

4. Finally, execute:

   ```
   dfx deploy
   ```

#### Front-End Testing

To access the front-end of your application, open a browser and paste:

```
http://127.0.0.1:8000/?canisterId=CANISTER_ID
```

 Replacing `CANISTER_ID` with the identifier of your ##### canister. The identifier should take the general form of `cxeji-wacaa-aaaaa-aaaaa-aaaaa-aaaaa-aaaaa-q`.