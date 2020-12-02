# Module 4: Autonomous Governance

In this module, you will build upon your work from modules 2 and 3 by implementing a "governance" canister that will act as the decentralized arbiter of our auction platform's feature upgrades. 

## Background

Refer to our section on [Autonomous Canisters](/module-1.md#Autonomous-Canisters) in Module 1 for a quick intro to this topic.

We ultimately want to create an automated canister that allows stakeholders to propose changes to our `App.mo` file. The governance canister enables these stakeholders to then vote on open proposals and will automatically migrate `App.mo` and replace it with the new, proposed file. This enables us to create "autonomous" system by which edits are suggested and then voted upon, ensuring that stakeholders will have guaranteed say in the process if initially given that power. 

## Your Task

We have provided you with starter code in `Governor.mo` - your job is to finish implementing all necessary methods such that we have a functional governance canister. 

### Code Understanding

#### `Governor.mo`

First, begin by studying the `Proposal ` variant type in `Types.mo` - possessing a clear understanding of what a proposal consists of is necessary for this module. To review, a `Proposal` maintains several key attributes:

* `newApp` is the canister id of the proposed changed to `App.mo` (in the form of any entirely new canister).
* `proposer` is the id of the canister creating the proposal. 
* `ttl`, which stand for time to live, signals the amount of time the proposal has before being cancelled. If a proposal isn't passed before we reach the specified `ttl` (which is a fixed time in the future, not a "countdown"), then the proposal is cancelled.
* `status` stores a `ProposalStatus` variant type, which (also defined in `Types.mo`) can be in one of four states:
  * `#active`: voting is ongoing.
  * `#cancelled`: the proposal was retracted by either the proposal owner or the owner of the `Governor` canister.
  * `#defeated`: the proposal was voted down by stakeholders.
  * `#succeeded`: the proposal passed.

Now let's take a look at `Governor`'s signature. We use the same `shared(msg)` parameter that was mentioned in Module 2, and we store the id of the canister that initialized the `Governor` in a variable named `owner` with:

```
let owner = msg.caller;
```

The `Governor` constructor takes two parameters: `starterApp` and `VoteThreshold`. `starterApp` is the id of the canister that stores our `App` actor, while `voteThreshold`, a float between 0 and 1, specifies the proportion of votes that a proposal must receive in order to pass and be enacted.

We create `proposals` to store all proposals that are proposed. Proposals remain in this list even after they have been cancelled, defeated, or succeeded.

The `propose` method, which has been implemented for you, accepts the id of a new proposed `App` canister. We use this `newApp` and the id of the canister that proposed it (stored in `msg.caller`) to create a new `Proposal` (which has been factored out by the helper `makeProposal`). Note that our `proposals` array is mutable, so we must first `freeze` the current array before appending our new `Proposal`. Finally, we `thaw` the array before reseting the value of `proposals`.

`checkProposal` checks if the given proposal has exceeded its `ttl`, and, if so, runs the necessary calculation to determine if the proposal status should switch to `#succeeded` or `#defeated`. We have created `checkProposal` and `_checkProposal` to allow this function to both be used within the `Governor` canister (as a helper in `voteOnProposal`) and for external canister calls. `checkProposal` is for external calls (hence the `async` result) while `_checkProposal` is for internal canister use only.

The `migrate` method performs the canister migration by replacing `currentApp` (which stores the canister of the current App for our auction system) with the Principal provided in the passed proposal. This only occurs once a proposal has been voted on and passes the desired threshold. 

### Specification

**Task:** Complete the implementation of the `cancelProposal` and `voteOnProposal` methods in `Governor.mo`.

**`cancelProposal`** enables the proposal owner or the `Governor` owner to cancel an active proposal

* `cancelProposal` accepts one parameter, a `propNum`, which represents the index of the proposal in the `proposals` list
* First, check that the `propNum` is a valid index (that it doesn't reference an out-of-bound index location based on the size of `proposals`)
  * If not, return the `#proposalNotFound` error (defined in `Types.mo`)
* We then want to ensure that the canister calling `cancelProposal` is either the owner of the proposal or the owner of the entire `Governor` canister
  * If not, return the `incorrectPermissions` error
  * Remember that we can access the caller of a method by querying the `caller` field of our `msg` record with `msg.caller`
* Finally, check that the proposals's current status is `active`. If so, change it to `#canceled` and return `#ok()`
  * If it is anything other than active, return the `#proposalNotActive` error

**`voteOnProposal`** allows stakeholders to vote for or against an active proposal

* Accepts two parameters: `propNum`, which represents the index of the proposal in the `proposals` list, and `vote`, which is a vote for the corresponding proposal (which must be the variant type `Vote`) 
* You must first check if the proposal is active (i.e. that it hasn't exceeded its time to live, or `ttl`) by calling `_checkProposal`
  * If `_checkProposal` throws an error, be sure to return that same error for `voteOnProposal` as well
* `_checkProposal` returns the status of the proposal that you passed in, so you must condition on this status
  * If the proposal is active, then increment either the `votesFor` or `votesAgainst` attributes of the given proposal depending on the `vote` that was cast
  * Otherwise, return the `#proposalNotActive` error



### Testing

Take a look at the [Developer Quick Start Guide](https://sdk.dfinity.org/docs/quickstart/quickstart.html) if you'd like a quick refresher on how to run programs on a locally-deployed IC network. 

Follow these steps to deploy your canisters and launch the front end. If you run into any issues, reference the **Quick Start Guide**, linked above,  for a more in-depth walkthrough.

1. Ensure that your dfx version matches the version shown in the `dfx.json` file by running the following command:

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