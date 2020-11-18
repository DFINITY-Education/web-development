import React from "react";
import { Link } from "wrouter";

const Navbar = () => {
  return (
    <nav className="nav-wrapper">
      <div className="container">
        <Link to="/" className="">AuctionHub</Link>
        <ul className="right">
            <li><Link to="/">Home</Link></li>
            <li><Link to="/bids">My Bids</Link></li>
            <li><Link to="/bids"><i className="material-icons">shopping_cart</i></Link></li>
        </ul>
      </div>
    </nav>
  );
}

export default Navbar;
