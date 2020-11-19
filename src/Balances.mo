import Array "mo:base/Array";
import HashMap "mo:base/HashMap";
import Principal "mo:base/Principal";

import Types "./Types";

shared {caller = owner} actor class Balances() {

  private type UserId = Types.UserId;
  private type Claim = Types.Claim;
  private type Result = Types.Result;

  private let userIdToBalance = HashMap.HashMap<UserId, Nat>(1, Principal.equal, Principal.hash);
  private let userIdToClaimableBalance = HashMap.HashMap<UserId, [Claim]>(1, Principal.equal, Principal.hash);

  public query func getBalance(user: UserId) : async (Nat) {
    switch (userIdToBalance.get(user)) {
      case (null) 0;
      case (?balance) balance;
    }
  };

  public shared {caller} func transferTo(user: UserId, _amount: Nat) : async (Result) {
    let balance = await getBalance(caller);
    if (_amount < balance) {
      #err(#insufficientBalance)
    } else {
      userIdToBalance.put(caller, balance - _amount);
      let claim: Claim = { from = caller; amount = _amount; };
      switch (userIdToClaimableBalance.get(user)) {
        case (null) userIdToClaimableBalance.put(user, [claim]);
        case (?claimArray) userIdToClaimableBalance.put(user, Array.append<Claim>(claimArray, [claim]));
      };

      #ok()
    }
  };

  public shared query {caller} func getClaimable(user: UserId) : async (Nat) {
    switch (userIdToClaimableBalance.get(caller)) {
      case (null) 0;
      case (?claimArray) {
        for (i in claimArray.vals()) {
          if (i.from == user) {
            return i.amount;
          };
        };
        0
      };
    }
  };

  public shared {caller} func deposit(user: UserId, amount: Nat) : async () {
    assert (owner == caller);
    userIdToBalance.put(user, (await getBalance(user)) + amount);
  };

};
