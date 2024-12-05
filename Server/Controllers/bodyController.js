const { body, validationResult } = require('express-validator');
const Body = require('../models/Body');

exports.postBody = async (req, res) => {
  await validationResult(req); // same structure as postDiet, add validations

  const { weight, height, advice } = req.body;
  try {
    const body = new Body({ weight, height, advice });
    await body.save();
    res.status(201).json({
      message: "Body data created successfully",
      body: { weight, height, advice }
    });
  } catch (error) {
    console.error("Error creating body data:", error);
    res.status(500).json({ message: "Error creating body data", error: error.message });
  }
};

exports.getBody = async (req, res) => {
  try {
    const bodies = await Body.find().select('-__v');
    res.json(bodies);
  } catch (error) {
    console.error("Error fetching body data:", error);
    res.status(500).json({ message: "Error fetching body data", error: error.message });
  }
};
