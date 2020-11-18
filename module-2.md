# Module 2: Open Auction Platform on the Internet Computer

In this Module, you will implement an auction platform, similar to an open version of eBay, as a web application. 



*[Insert photo of rudimentary front-end view]*



## Background



## Your Task

We have provided you with an incomplete base canister and rudimentary front end - your job is to implement the necessary methods to get the application functioning correctly.



### Code Understanding



#### `App.mo`



#### `Balances.mo` 



#### `Governor.mo`



#### `Main.mo` 



### Specification

**Task:** Complete the implementation of the ######## methods in `####.mo`.



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

2. Open a second terminal window (so you can start and view network operations without conflicting with the management of your project) and navigate to the same `\web-development` directory.

   In this new window, run:

   ```
   dfx start
   ```

3. Navigate back to your main terminal window and execute:

   ```
   dfx deploy
   ```

#### Front-End Testing

To access the front-end of your application, open a browser and paste:

```
http://127.0.0.1:8000/?canisterId=CANISTER_ID
```

 Replacing `CANISTER_ID` with the identifier of your ##### canister. The identifier should take the general form of `cxeji-wacaa-aaaaa-aaaaa-aaaaa-aaaaa-aaaaa-q`.