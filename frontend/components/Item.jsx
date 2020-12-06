import * as React from "react";
import {useState, useEffect} from "react";
import PropTypes from "prop-types";
import Button from "react-bootstrap/Button";
import Card from "react-bootstrap/Card";
import Form from "react-bootstrap/Form";

const simulateNetworkRequest = () => {
  return new Promise((resolve) => setTimeout(resolve, 2000));
};

const Item = ({ name, description, imageUrl }) => {
  let [currentBid, setCurrentBid] = useState(0);
  const [isLoading, setLoading] = useState(false);

  const handleClick = () => setLoading(true);

  useEffect(() => {
    if (isLoading) {
      simulateNetworkRequest().then(() => {
        setLoading(false);
      });
    }
  }, [isLoading]);

  const handleSubmit = (event) => {
    event.preventDefault();
    event.stopPropagation();

    const formData = new FormData(event.target);
    const formDataObj = Object.fromEntries(formData.entries());

    if (!isLoading) setLoading();
    if (formDataObj.bid > currentBid) setCurrentBid(formDataObj.bid);
  };

  return (
    <Card style={{ width: '18rem' }}>
      <Card.Img variant="top" src={imageUrl} />
      <Card.Body>
        <Card.Title>{name}</Card.Title>
        <Card.Text>{description}</Card.Text>
        <Form noValidate onSubmit={handleSubmit}>
          <Form.Group>
            <Form.Control name="bid" type="number" placeholder="Bid Amount" />
            <Form.Text className="text-muted">
              Minimum bid allowed: {currentBid.toString()}
            </Form.Text>
          </Form.Group>
          <Button
            variant="secondary"
            disabled={isLoading}>{
              isLoading ? "Bidding…" : "Bid"
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
