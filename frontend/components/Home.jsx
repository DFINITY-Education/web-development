import React, { Component } from "react";

class Home extends Component {

  constructor(props) {
    super(props);
    this.state = { items: [] };
  }

  render() {
    let itemList = this.state.items.map( (item) => {
      return(
        <div className="card" key={item.id}>
          <div className="card-image">
            <img src={item.img} alt={item.title}/>
            <span className="card-title">{item.title}</span>
            <span to="/" className="btn-floating halfway-fab waves-effect waves-light red" onClick={() => this.handleClick(item.id)}>
              <i className="material-icons">add</i>
            </span>
          </div>

          <div className="card-content">
            <p>{item.desc}</p>
            <p><b>Price: {item.price}$</b></p>
          </div>
        </div>
      )
    });

    return (
      <div className="container">
        <h3 className="center">Auctions</h3>
        <div className="box">
            {itemList}
        </div>
      </div>
    );
  }
}

export default Home;