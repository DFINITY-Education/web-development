import Array "mo:base/Array";
import HashMap "mo:base/HashMap";
import Principal "mo:base/Principal";
import Time "mo:base/Time";

import Balances "canister:balances";

import Types "./Types";

module {

  private type UserId = Types.UserId;
  private type Auction = Types.Auction;
  private type Item = Types.Item;
  private type Result = Types.Result;

  public class App() {
    private var items: [Item] = [];
    private var activeAuctions: [var Auction] = [var];

    public func auctionItem(
      caller: UserId,
      name: Text,
      description: Text,
      url: Text,
      startingBid: Nat
    ) {
      let item = makeItem(name, description, url);
      items := Array.append<Item>(items, [item]);
      let auction = makeAuction(caller, items.size(), startingBid);
      activeAuctions := Array.thaw<Auction>(
        Array.append<Auction>(Array.freeze<Auction>(activeAuctions), [auction])
      );
    };

    public func makeBid(caller: Principal, auctionId: Nat, amount: Nat) : (Result) {
      let balance = Balances.getBalance(caller);
      if (amount > balance) return #err(#insufficientBalance);
      let auction = activeAuctions[auctionId];
      switch (auction.highestBidder) {
        case (null) {
          if (amount > auction.startingBid) {
            activeAuctions[auctionId] := setNewBidder(auction, caller, amount);
            #ok()
          } else {
            #err(#belowMinimumBid)
          }
        };
        case (?bidder) {
          if (amount > auction.highestBid) {
            activeAuctions[auctionId] := setNewBidder(auction, caller, amount);
            #ok()
          } else {
            #err(#belowMinimumBid)
          }
        };
      }
    };

  };

  private func makeItem(_name: Text, _description: Text, _url: Text) : (Item) {
    {
      name = _name;
      description = _description;
      url = _url;
    }
  };

  private func makeAuction(
    _owner: UserId,
    _itemNum: Nat,
    _startingBid: Nat,
  ) : (Auction) {
    {
      owner = _owner;
      itemNum = _itemNum;
      startingBid = _startingBid;
      var highestBid = 0;
      var highestBidder = null;
      ttl = Time.now();
    }
  };

  private func setNewBidder(auction: Auction, bidder: Principal, bid: Nat) : (Auction) {
    auction.highestBid := bid;
    auction.highestBidder := ?bidder;
    auction
  };

};
