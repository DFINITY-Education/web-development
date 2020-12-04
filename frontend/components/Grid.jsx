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
        (item, index) => <Item key={index} name={item.name} description={item.description} imageUrl={item.imageUrl} minBid={item.minBid} />,
      )
    }</GridLayout>
  );
};

Grid.propTypes = {
  itemList: PropTypes.array.isRequired,
};

export default Grid;
