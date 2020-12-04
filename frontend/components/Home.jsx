import * as React from "react";
import PropTypes from 'prop-types';
import Form from "react-bootstrap/Form";
import Navbar from "react-bootstrap/Navbar";
import NavDropdown from "react-bootstrap/NavDropdown";

import Grid from "./Grid";

const Home = (props) => {

  return (
    <>
      <Navbar bg="dark" variant="dark">
        <Navbar.Brand href="#home">Auctions</Navbar.Brand>
        <NavDropdown title="Dropdown" id="collasible-nav-dropdown">
          <Form inline>
            <Form.File 
              id="custom-file"
              label="Image Upload"
              custom
            />
          </Form>
        </NavDropdown>
      </Navbar>
      <div className='mt-5' />
      <Grid itemList={props.itemList} />
    </>
  );
};

Home.propTypes = {
  itemList: PropTypes.array.isRequired,
};

export default Home;
