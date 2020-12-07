import * as React from "react";
import {useState} from "react";
import web_development from 'ic:canisters/web_development';

import Home from './components/Home';

const App = async () => {
  await web_development.setup();
  const appAuctionList = await web_development.getAuctions();
  const [itemList, setitemList] = useState(appAuctionList);

  return (
    <Home itemList={itemList} setter={setitemList} />
  );
};

export default App;
