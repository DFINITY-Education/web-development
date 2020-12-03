import * as React from 'react';
import web_development from 'ic:canisters/web_development';

import Home from './components/Home';

const App = () => {
  return (
    <div style={{ "font-size": "30px" }}>
      <div style={{ "background-color": "yellow" }}>
        <Home />
        <p>Greetings, from DFINITY!</p>
      </div>
    </div>
  );
};

export default App;
