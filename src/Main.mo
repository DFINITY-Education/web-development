import Principal "mo:base/Principal";

import App "./App";
import Balances "./Balances";
import Governor "./Governor";
import Types "./Types";

actor {

  func  setup() : async () {
    let balances = await Balances.Balances();
    let app = await App.App(Principal.fromActor(balances));

    let balancesGov = await Balances.Balances();
    let governor = await Governor.Governor(
      Principal.fromActor(app),
      Principal.fromActor(balancesGov),
      0.5
    );
  };

};
