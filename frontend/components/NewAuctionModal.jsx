import * as React from "react";
import {useState} from "react";
import PropTypes from "prop-types";
import Button from "react-bootstrap/Button";
import Form from "react-bootstrap/Form";
import Modal from "react-bootstrap/Modal";
import web_development from 'ic:canisters/web_development';

const NewAuctionModal = ({show, onHide, addToAuctions}) => {
  const [validated, setValidated] = useState(false);

  const handleSubmit = (event) => {
    event.preventDefault();
    event.stopPropagation();

    const form = event.target;

    if (form.checkValidity() === true) {
      const formData = new FormData(event.target);
      const formDataObj = Object.fromEntries(formData.entries());
      formDataObj.minBid = 0;
      formDataObj.imageUrl = formDataObj.image.size > 0 ? URL.createObjectURL(formDataObj.image) : "https://www.watershedcabins.com/uploads/for-sale-sign-e1509648047898-400x234.jpg";

      addToAuctions(currentItemList => [...currentItemList, formDataObj]);

      setValidated(true);
      onHide();
      form.reset();
    }
  };

  return (
    <Modal show={show} onHide={onHide}>
      <Modal.Header closeButton>
        <Modal.Title>New Auction</Modal.Title>
      </Modal.Header>
      <Modal.Body>
        <Form noValidate validated={validated} onSubmit={handleSubmit}>
          <Form.Group>
            <Form.Label>Item Name</Form.Label>
            <Form.Control
              required
              name="name"
              type="text"
              placeholder="Please provide a valid item name"
            />
            <Form.Control.Feedback>Looks good!</Form.Control.Feedback>
          </Form.Group>
          <Form.Group>
            <Form.Label>Description</Form.Label>
            <Form.Control
              required
              name="description"
              as="textarea"
              rows={3}
              placeholder="Please provide a valid description"
            />
            <Form.Control.Feedback>Looks good!</Form.Control.Feedback>
          </Form.Group>
          <Form.Group>
            <Form.File name="image" label="Image Upload (optional)" />
          </Form.Group>
          <Button className="float-right" type="submit">Submit form</Button>
        </Form>
      </Modal.Body>
    </Modal>
  );
};

NewAuctionModal.propTypes = {
  show: PropTypes.bool.isRequired,
  onHide: PropTypes.func.isRequired,
  addToAuctions: PropTypes.func.isRequired,
};

export default NewAuctionModal;
