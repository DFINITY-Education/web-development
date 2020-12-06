import * as React from "react";
import PropTypes from 'prop-types';
import Button from "react-bootstrap/Button";
import Nav from "react-bootstrap/Nav";
import Navbar from "react-bootstrap/Navbar";

import Grid from "./Grid";
import NewAuctionModal from "./NewAuctionModal";

const Home = (props) => {
  const [show, setShow] = React.useState(false);

  const handleClose = () => setShow(false);
  const handleShow = () => setShow(true);

  return (
    <>
      <Navbar bg="dark" variant="dark">
        <Navbar.Brand>AuctionHub</Navbar.Brand>
        <Nav className="mr-auto">
          <Nav.Link>My Bids</Nav.Link>
          <Nav.Link>My Auctions</Nav.Link>
          <Nav.Link>Expiring Soon</Nav.Link>
        </Nav>
        <Nav>
          <Button variant="primary" onClick={handleShow}>
            New Auction
          </Button>
          <NewAuctionModal
            show={show}
            onHide={handleClose}
            addToAuctions={props.setter}
          />
        </Nav>
      </Navbar>
      <div className='mt-5' />
      <Grid itemList={props.itemList} />
    </>
  );
};

Home.propTypes = {
  itemList: PropTypes.array.isRequired,
  setter: PropTypes.func.isRequired,
};

export default Home;
