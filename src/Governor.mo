import Array "mo:base/Array";
import Time "mo:base/Time";

import Types "./Types";

shared {caller = owner} actor class Governor(starterApp: Principal, voteThreshold: Float) {

  private type ProposalStatus = Types.ProposalStatus;
  private type Proposal = Types.Proposal;
  private type Result = Types.GovResult;
  private type Vote = Types.Vote;

  // This should use BigMap
  private var proposals: [var Proposal] = [var];

  public shared {caller} func propose(newApp: Principal) {
    proposals := Array.thaw<Proposal>(
      Array.append<Proposal>(Array.freeze<Proposal>(proposals), [makeProposal(newApp, caller)]));
  };

  public shared {caller} func cancelProposal(propNum: Nat) : async (Result) {
    if (proposals.size() < propNum) return #err(#proposalNotFound);
    let prop = proposals[propNum];
    if (caller != owner and caller != prop.proposer) return #err(#incorrectPermissions);
    switch (prop.status) {
      case (#active) {
        prop.status := #canceled;
        proposals[propNum] := prop;
        #ok()
      };
      case (_) #err(#proposalNotActive);
    }
  };

  // public func voteOnProposal(propNum: Nat, vote: Vote) : async (Result) {
  //   if (proposals.size() < propNum) return #err(#propNotFound);
  //   let prop = proposals[propNum];
  //   switch (prop.status) {
  //     case (#active) {
  //       switch (vote) {
  //         case (#inFavor) prop.votesFor += 1;
  //         case (#against) prop.votesFor += 1;
  //       };
  //       proposals[propNum] := prop;
  //       #ok()
  //     };
  //     case (_) #err(#proposalNotActive);
  //   }
  // };

  private func makeProposal(_newApp: Principal, _proposer: Principal) : (Proposal) {
    {
      newApp = _newApp;
      proposer = _proposer;
      var votesFor = 0;
      var votesAgainst = 0;
      var status: ProposalStatus = #active;
      ttl = Time.now() + (3600 * 1000_000_000);
    }
  };

};
