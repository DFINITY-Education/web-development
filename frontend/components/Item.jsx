import * as React from "react";
import { useEffect, useRef, useState } from "react";
import PropTypes from "prop-types";
import Button from "react-bootstrap/Button";
import Card from "react-bootstrap/Card";
import Form from "react-bootstrap/Form";

const simulateNetworkRequest = () => {
  return new Promise((resolve) => setTimeout(resolve, 1000));
};

const Item = ({ name, description, imageUrl }) => {
  let [currentBid, setCurrentBid] = useState(0);
  const [isLoading, setLoading] = useState(false);
  const [validInput, setValidInput] = useState(false);
  const formRef = useRef(null);

  useEffect(() => {
    if (isLoading) {
      simulateNetworkRequest().then(() => {
        setLoading(false);
      });
    }
  }, [isLoading]);

  const checkInput = (event) => {
    const val = event.target.value;
    setValidInput(
      !isNaN(val) &&
      parseInt(Number(val)) == val &&
      !isNaN(parseInt(val, 10)) &&
      val > currentBid);
  };

  const handleSubmit = (event) => {
    event.preventDefault();
    event.stopPropagation();

    const formData = new FormData(event.target);
    const formDataObj = Object.fromEntries(formData.entries());
    const bid = formDataObj.bid;

    if (validInput) {
      if (!isLoading) setLoading(true);
      setCurrentBid(bid);
      formRef.current.reset();
    }
  };

  return (
    <Card style={{ width: '18rem' }}>
      <Card.Img variant="top" src={imageUrl} />
      <Card.Body>
        <Card.Title>{name}</Card.Title>
        <Card.Text>{description}</Card.Text>
        <Form noValidate onSubmit={handleSubmit} ref={formRef}>
          <Form.Group>
            <Form.Control
              name="bid"
              type="number"
              onChange={checkInput}
              min="1"
              placeholder="Bid Amount"
            />
            <Form.Text className="text-muted">
              Minimum bid allowed: {currentBid.toString()}
            </Form.Text>
          </Form.Group>
          <Button
            variant={validInput ? "primary" : "secondary"}
            type="submit"
            disabled={isLoading || !validInput}>{
              isLoading ? "Bidding..." : "Bid"
          }</Button>
        </Form>
      </Card.Body>
    </Card>
  );
};

Item.propTypes = {
  name: PropTypes.string.isRequired,
  description: PropTypes.string.isRequired,
  imageUrl: PropTypes.string.isRequired,
  minBid: PropTypes.number.isRequired,
};

export default Item;
