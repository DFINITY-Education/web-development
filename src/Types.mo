import Hash "mo:base/Hash";
import Nat "mo:base/Nat";
import Result "mo:base/Result";

module {

  public type UserId = Principal;
  public type Result = Result.Result<(), Error>;
  public type GovResult = Result.Result<(), GovError>;

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

  public type ProposalStatus = {
    #active;
    #canceled;
    #defeated;
    #succeeded;
  };

  public type Proposal = {
    newApp: Principal;
    proposer: Principal;
    var votesFor: Nat;
    var votesAgainst: Nat;
    var status: ProposalStatus;
    ttl: Int;
  };

  public type Error = {
    #belowMinimumBid;
    #insufficientBalance;
    #itemNotFound;
    #userNotFound;
  };

  public type Vote = {
    #inFavor;
    #against;
  };

  public type GovError = {
    #incorrectPermissions;
    #proposalNotFound;
    #proposalNotActive;
  };

};
