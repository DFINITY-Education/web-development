import * as React from 'react';
import web_development from 'ic:canisters/web_development';

import Home from './components/Home';

const App = () => {
  const [itemList, setitemList] = React.useState([]);

  return (
    <Home itemList={itemList} setter={setitemList} />
  );
};

export default App;
