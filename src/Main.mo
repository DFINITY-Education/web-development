import App "./App";
import Balances "./Balances";
import Governor "./Governor";
import Types "./Types";

actor {

  let app = await App.App();
  let governor = await Governor.Governor();
  let balances = await Balances.Balances();
  let balancesGov = await Balances.Balances();

};
