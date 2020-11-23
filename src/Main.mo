import Principal "mo:base/Principal";

import App "./App";
import Balances "./Balances";
import Governor "./Governor";
import Types "./Types";

actor {

  func  setup() : async () {
    let balances = await Balances.Balances();
    let app = await App.App(Principal.fromActor(balances));
    let governor = await Governor.Governor(Principal.fromActor(app), 0.5);
  };

};
