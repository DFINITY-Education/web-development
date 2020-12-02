import Array "mo:base/Array";
import Hash "mo:base/Hash";
import HashMap "mo:base/HashMap";
import Nat "mo:base/Nat";
import Principal "mo:base/Principal";
import Time "mo:base/Time";

import Balances "./Balances";
import Types "./Types";

actor class App(balancesAddr: Principal) = App {

  type AuctionId = Types.AuctionId;
  type UserId = Types.UserId;
  type Auction = Types.Auction;
  type Item = Types.Item;
  type Result = Types.Result;

  let balances = actor (Principal.toText(balancesAddr)) : Balances.Balances;

  let auctions = HashMap.HashMap<AuctionId, Auction>(1, Nat.equal, Hash.hash);
  var auctionCounter = 0;

  /// Creates a new item and corresponding auction.
  /// Args:
  ///   |owner|       The UserId of the auction owner.
  ///   |name|         The item's name.
  ///   |description|  The item's description.
  ///   |url|          The URL the auction can be accesses at.
  ///   |startingBid|  The starting bid amount.
  public func auctionItem(
    owner: UserId,
    name: Text,
    description: Text,
    url: Text,
    startingBid: Nat
  ) {
    let item = makeItem(name, description, url);
    let auction = makeAuction(owner, item, startingBid);
    auctions.put(auctionCounter, auction);
    auctionCounter += 1;
  };

  /// Records a new user bid for an auction.
  /// Args:
  ///   |bidder|     The UserId of the bidder.
  ///   |auctionId|  The id of the auction.
  ///   |amount|     The user's bit amount.
  /// Returns:
  ///   A Result indicating if the bid was successfully processed (see "Error" in Types.mo for possible errors).
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
              let myPrincipal = Principal.fromActor(App);
              ignore balances.transfer(bidder, myPrincipal, amount);
              ignore balances.transfer(myPrincipal, previousHighestBidder, auction.highestBid);
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

  /// Helper method used to create a new item (used in auctionItem).
  /// Args:
  ///   |_name|         The item's name.
  ///   |_description|  The item's description.
  ///   |_url|          The URL the auction can be accesses at.
  /// Returns:
  ///   The newly created Item (see Item in Types.mo)
  func makeItem(_name: Text, _description: Text, _url: Text) : (Item) {
    {
      name = _name;
      description = _description;
      url = _url;
    }
  };

  /// Helper method used to create a new item (used in auctionItem).
  /// Args:
  ///   |_owner|         The auction's owner.
  ///   |_item|          The item object.
  ///   |_startingBid|   The starting bid of the auction.
  /// Returns:
  ///   The newly created Auction (see Auction in Types.mo)
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

  /// Helper method used to set a new highest bidder in an auction (used in makeBid).
  /// Args:
  ///   |auction|  The auction id.
  ///   |bidder|   The highest bidder's Principal id.
  ///   |bid|      The highest bid of the auction.
  /// Returns:
  ///   The updated Auction (see Auction in Types.mo)
  func setNewBidder(auction: Auction, bidder: Principal, bid: Nat) : (Auction) {
    auction.highestBid := bid;
    auction.highestBidder := ?bidder;
    auction
  };

};
