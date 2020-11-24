import Array "mo:base/Array";
import Hash "mo:base/Hash";
import HashMap "mo:base/HashMap";
import Nat "mo:base/Nat";
import Principal "mo:base/Principal";
import Time "mo:base/Time";

import Balances "./Balances";
import Types "./Types";

actor class App(balancesAddr: Principal) {

  type AuctionId = Types.AuctionId;
  type UserId = Types.UserId;
  type Auction = Types.Auction;
  type Item = Types.Item;
  type Result = Types.Result;

  let balances = actor (Principal.toText(balancesAddr)) : Balances.Balances;

  let auctions = HashMap.HashMap<AuctionId, Auction>(1, Nat.equal, Hash.hash);
  var auctionCounter = 0;

  public func auctionItem(
    caller: UserId,
    name: Text,
    description: Text,
    url: Text,
    startingBid: Nat
  ) {
    let item = makeItem(name, description, url);
    let auction = makeAuction(caller, item, startingBid);
    auctions.put(auctionCounter, auction);
    auctionCounter += 1;
  };

  public func makeBid(bidder: Principal, auctionId: Nat, amount: Nat) : async (Result) {
    let balance = await balances.getBalance(bidder);
    if (amount > balance) return #err(#insufficientBalance);

    let auctionCheck = auctions.get(auctionId);
    switch (auctionCheck) {
      case (null) {
        #err(#auctionNotFound)
      };
      case (?auction) {
        switch (auction.highestBidder) {
          case (null) {
            auctions.put(auctionId, setNewBidder(auction, bidder, amount));
            #ok()
          };
          case (?previousHighestBidder) {
            if (amount > auction.highestBid) {
              // TODO: How to reference self Principal?
              // balances.transfer(bidder, self, amount);
              // balances.transfer(self, previousHighestBidder, auction.highestBid);
              auctions.put(auctionId, setNewBidder(auction, bidder, amount));
              #ok()
            } else {
              #err(#belowMinimumBid)
            }
          };
        }
      };
    }
  };

  func makeItem(_name: Text, _description: Text, _url: Text) : (Item) {
    {
      name = _name;
      description = _description;
      url = _url;
    }
  };

  func makeAuction(
    _owner: UserId,
    _item: Item,
    _startingBid: Nat,
  ) : (Auction) {
    {
      owner = _owner;
      item = _item;
      startingBid = _startingBid;
      var highestBid = 0;
      var highestBidder : ?Principal = null;
      ttl = Time.now() + (3600 * 1000_000_000);
    }
  };

  func setNewBidder(auction: Auction, bidder: Principal, bid: Nat) : (Auction) {
    auction.highestBid := bid;
    auction.highestBidder := ?bidder;
    auction
  };

};
