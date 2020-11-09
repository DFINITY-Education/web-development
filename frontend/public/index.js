import { React } from "react";
import { render } from "react-dom";

import App from "./App.jsx";
import web_development from 'ic:canisters/web_development';


// render(<App />, document.getElementById("app"));
web_development.greet(window.prompt("Enter your name:")).then(greeting => {
  window.alert(greeting);
});
