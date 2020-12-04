import * as React from "react";
import PropTypes from 'prop-types';
import Button from "react-bootstrap/Button";
import Card from "react-bootstrap/Card";
import Form from "react-bootstrap/Form";

const Item = ({ name, description, imageUrl, minBid }) => {
  return (
    <Card style={{ width: '18rem' }}>
      <Card.Img variant="top" src={imageUrl} />
      <Card.Body>
        <Card.Title>{name}</Card.Title>
        <Card.Text>{description}</Card.Text>
        
        <Form>
          <Form.Group>
            <Form.Control type="number" placeholder="Bid Amount" />
            <Form.Text className="text-muted">
              Minimum bid allowed: {minBid.toString()}
            </Form.Text>
          </Form.Group>
          <Button variant="primary" type="submit">Bid</Button>
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
