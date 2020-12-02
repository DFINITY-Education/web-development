import Array "mo:base/Array";
import HashMap "mo:base/HashMap";
import Principal "mo:base/Principal";

import Types "./Types";

shared(msg) actor class Balances() {

  type UserId = Types.UserId;
  type Result = Types.Result;

  // Stores the Principal of the canister that created Balances (for permission purposes).
  let owner = msg.caller;

  let userIdToBalance = HashMap.HashMap<UserId, Nat>(1, Principal.equal, Principal.hash);

  /// Retrieves the balance of the given |user|. Accessible to external canisters.
  ///   This is the public-facing version. See _getBalance for the version accessible to other methods in this actor.
  /// Args:
  ///   |user|   The UserId of the user whose balance we want to access.
  /// Returns:
  ///   A Nat representing the user balance
  public query func getBalance(user: UserId) : async (Nat) {
    _getBalance(user)
  };

  /// Transfers money between users (used for payment after transactions).
  /// Args:
  ///   |from|    The UserId of the user whose balance we transfer from.
  ///   |to|      The UserId of the user whose balance we transfer to.
  ///   |_amount| The amount of money to be transferred.
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

  /// Deposits money into a user account. Used to initialize user balances upon start of the application.
  /// Args:
  ///   |user|    The UserId of the user whose balance we deposit to
  ///   |amount| The amount of money to be deposited.
  public shared(msg) func deposit(user: UserId, amount: Nat) : async () {
    assert (owner == msg.caller);
    userIdToBalance.put(user, (await getBalance(user)) + amount);
  };

  /// Retrieves the balance of the given |user|. Used as a helper function for other methods in this actor.
  ///   This is the internal-facing version. See getBalance for the version accessible to external canisters
  /// Args:
  ///   |user|   The UserId of the user whose balance we want to access.
  /// Returns:
  ///   A Nat representing the user balance
  func _getBalance(user: UserId) : (Nat) {
    switch (userIdToBalance.get(user)) {
      case (null) 0;
      case (?balance) balance;
    }
  };

};
