import * as React from "react";
import { useEffect, useState } from "react";

import web_development from 'ic:canisters/web_development';

import Grid from "./components/Grid";
import AuctionNavbar from "./components/AuctionNavbar";

/** Retrieves auctions from App canister. */
async function getAuctions() {
  // YOUR CODE HERE
}

const App = () => {
  const [itemList, setItemList] = useState([]);

  useEffect(() => {
    async function setup() {
    /*
      console.log("in setup");
      await web_development.deployBalances();
      console.log("after deployBalances");
      await web_development.deployApp();
      console.log("after deployApp");
      await web_development.deployGovernor();
      console.log("after deployGovernor");
    */
      await web_development.deployAll(); // responds promptly
      console.log("initiated deployAll");
      // poll until isReady()
      while (!(await web_development.isReady())) {
        console.log("polled isReady");
        await new Promise(r => setTimeout(r, 2000));
      };
      const auctionList = await web_development.getAuctions();
      console.log("after getAuctions");
      console.log(auctionList);
      setItemList([auctionList[1].item]); // unrelated existing bug here?
    }
    setup();
  }, []);

  return (
    <>
      <AuctionNavbar setter={setItemList} />
      <div className='mt-5' />
      <Grid itemList={itemList} />
    </>
  );
};

export default App;
