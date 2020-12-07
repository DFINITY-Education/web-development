import * as React from "react";
import { useEffect, useState } from "react";
import web_development from 'ic:canisters/web_development';

import Grid from "./components/Grid";
import AuctionNavbar from "./components/AuctionNavbar";

const App = () => {
  const [itemList, setitemList] = useState([]);

  useEffect(() => {
    if (itemList.length === 0) {
      setup();
    }
  }, []);

  const setup = async () => {
    await web_development.setup();
    const appAuctionList = await web_development.getAuctions();
    setitemList(appAuctionList);
  };

  return (
    <>
      <AuctionNavbar setter={setitemList} />
      <div className='mt-5' />
      <Grid itemList={itemList} />
    </>
  );
};

export default App;
