import Hash "mo:base/Hash";
import Nat "mo:base/Nat";
import Result "mo:base/Result";

module {

  public type UserId = Principal;
  public type Result = Result.Result<(), Error>;

  public type Auction = {
    owner: UserId;
    itemNum: Nat;
    startingBid: Nat;
    var highestBid: Nat;
    var highestBidder: ?UserId;
    ttl: Int;
  };

  public type Item = {
    name: Text;
    description: Text;
    url: Text;
  };

  public type Claim = {
    from: UserId;
    amount: Nat;
  };

  public type Error = {
    #belowMinimumBid;
    #insufficientBalance;
    #itemNotFound;
    #userNotFound;
  };

};
