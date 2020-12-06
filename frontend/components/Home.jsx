import * as React from "react";
import PropTypes from 'prop-types';

import Grid from "./Grid";
import AuctionNavbar from "./AuctionNavbar";

const Home = (props) => {
  return (
    <>
      <AuctionNavbar setter={props.setter} />
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
