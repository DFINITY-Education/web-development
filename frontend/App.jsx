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
      console.log("in setup");
      await web_development.setup();
      const auctionList = await web_development.getAuctions();
      console.log(auctionList);
      setItemList(auctionList);
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
