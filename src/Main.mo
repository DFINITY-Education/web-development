import Principal "mo:base/Principal";
import Result "mo:base/Result";

import App "./App";
import Balances "./Balances";
import Governor "./Governor";
import Types "./Types";

actor {

  type App = App.App;
  type Balances = Balances.Balances;
  type Governor = Governor.Governor;

  type Result = Result.Result<(), Types.GovError>;

  // var app : App = actor {};
  // var balances = actor {};
  // var governor : Governor = actor {};

  public shared(msg) func setup() : async () {
    // balances = await Balances();
    // balances.deposit(msg.caller, 100);
    // app = await App(Principal.fromActor(balances));
    // governor = await Governor(Principal.fromActor(app), 0.5);
  };

  // public shared(msg) func propose(newApp: Principal) : async () {
  //   governor.propose(newApp);
  // };

  // public shared(msg) func voteForProp(propNum: Nat) : async (Result) {
  //   await governor.voteOnProposal(propNum, #inFavor)
  // };

  // public shared(msg) func voteAgainstProp(propNum: Nat) : async (Result) {
  //   await governor.voteOnProposal(propNum, #against)
  // };

};
