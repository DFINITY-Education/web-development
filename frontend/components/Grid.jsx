import * as React from "react";
import PropTypes from "prop-types";
import { GridLayout } from "@egjs/react-infinitegrid";

import Item from "./Item";

const Grid = (props) => {
  return (
    <GridLayout
      options={{
        isConstantSize: true,
        transitionDuration: 0.2,
      }}
      layoutOptions={{
        margin: 10,
        align: "center",
    }}>{
      props.itemList.map(
        item => <Item key={props.auctionId} name={item.name} description={item.description} imageUrl={item.imageUrl} />,
      )
    }</GridLayout>
  );
};

Grid.propTypes = {
  auctionId: PropTypes.number.isRequired,
  itemList: PropTypes.array.isRequired,
};

export default Grid;
