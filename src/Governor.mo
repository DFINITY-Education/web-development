import Time "mo:base/Time";

import Types "./Types";

shared {caller = owner} actor class Governor(starterApp: Principal, voteThreshold: Float) {

  private type Proposal = Types.Proposal;
  private type Result = Types.GovResult;
  private type Vote = Types.Vote;

  // This should use BigMap
  private let proposals: [Proposal] = [];

  public func propose(newApp: Principal) {
    proposals.push(makeProposal(newApp));
  };

  public shared {caller} cancelProposal(propNum: Nat) : Result {
    if (proposals.size() < propNum) return #err(#propNotFound);
    let prop = proposals[propNum];
    if (caller != owner && caller != prop.proposer) return #err(#incorrectPermissions);
    switch (prop.status) {
      case (#active) {
        prop.status := #canceled;
        proposals[propNum] := prop;
        #ok()
      };
      case (_) #err(#proposalNotActive);
    }
  };

  public func voteOnProposal(propNum: Nat, vote: Vote) : Result {
    if (proposals.size() < propNum) return #err(#propNotFound);
    let prop = proposals[propNum];
    switch (prop.status) {
      case (#active) {
        switch (vote) {
          case (#inFavor) prop.votesFor += 1;
          case (#against) prop.votesFor += 1;
        };
        proposals[propNum] := prop;
        #ok()
      };
      case (_) #err(#proposalNotActive);
    }
  };

  private query makeProposal(_newApp: Principal) : Proposal {
    {
      newApp = _newApp;
      votesFor = 0;
      votesAgainst = 0;
      status = #active;
      ttl = Time.now() + (3600 * 1000_000_000);
    }
  };

};
