import React from "react";
import { GridLayout } from "@egjs/react-infinitegrid";

import { Item } from "./Item";

const Grid = () => {
  return (
    <GridLayout
      tag = "div"
      useFirstRender={false}
      loading={<div>Loading...</div>}
      options={{
        threshold: 100,
        isOverflowScroll: false,
        isEqualSize: false,
        isContantSize: false,
        useFit: false,
        useRecycle: false,
        horizontal: false,
      }}
      layoutOptions={{
        align: "justify",
      }}
      // onAppend = {e => append}
      // onPrepend = {e => append}
      // onLayoutComplete = {e => layoutComplete}
      // onImageError = {e => imageError}
      // onChange = {e => chnage}
    >
      <Item />
      <Item />
      <Item />
      <Item />
    </GridLayout>
  );
};

export default Grid;
