import Array "mo:base/Array";
import HashMap "mo:base/HashMap";
import Principal "mo:base/Principal";

import Types "./Types";

shared(msg) actor class Balances() {

  type UserId = Types.UserId;
  type Result = Types.Result;

  let owner = msg.caller;

  let userIdToBalance = HashMap.HashMap<UserId, Nat>(1, Principal.equal, Principal.hash);

  public query func getBalance(user: UserId) : async (Nat) {
    _getBalance(user)
  };

  public shared(msg) func transfer(
    from: UserId,
    to: UserId,
    _amount: Nat
  ) : async (Result) {
    let fromBalance = _getBalance(from);
    if (_amount < fromBalance) {
      #err(#insufficientBalance)
    } else {
      let toBalance = _getBalance(to);
      userIdToBalance.put(from, fromBalance - _amount);
      userIdToBalance.put(to, toBalance + _amount);

      #ok()
    }
  };

  public shared(msg) func deposit(user: UserId, amount: Nat) : async () {
    assert (owner == msg.caller);
    userIdToBalance.put(user, (await getBalance(user)) + amount);
  };

  func _getBalance(user: UserId) : (Nat) {
    switch (userIdToBalance.get(user)) {
      case (null) 0;
      case (?balance) balance;
    }
  };

};
