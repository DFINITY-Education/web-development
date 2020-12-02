import custom_greeting from 'ic:canisters/web_development';
import * as React from 'react';
import { render } from 'react-dom';

class BasicComponent extends React.Component {
  constructor(props) {
    super(props);
    this.state = {};
  }

  render() {
    return (
      <div style={{ "font-size": "30px" }}>
        <div style={{ "background-color": "yellow" }}>
          <p>Greetings, from DFINITY!</p>
        </div>
      </div>
    );
  }
}

render(<BasicComponent />, document.getElementById('app'));