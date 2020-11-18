import React from "react";
import { Route } from "wrouter";

import Home from "./components/Home";
import Navbar from "./components/Navbar";

import web_development from 'ic:canisters/web_development';

class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      itemsForSale: [],
      users: [],
    };
  }

  render() {
    return (
      <div>
        <Navbar>
          <Route exact path='/' component={Home}/>
        </Navbar>
      </div>
    );
  }
}

export default App;
