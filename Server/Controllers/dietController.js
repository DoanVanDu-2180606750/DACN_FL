const { body, validationResult } = require('express-validator');
const Diet = require('../Models/Diet');

exports.postDiet = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(422).json({ errors: errors.array() });
  }

  const { name, calories, protein, fat, fiber, type } = req.body;
  try {
    const existingDiet = await Diet.findOne({ name });
    if (existingDiet) {
      return res.status(400).json({ message: "Food already exists" });
    }
    
    const diet = new Diet({ name, calories, protein, fat, fiber, type });
    await diet.save();
    res.status(201).json({
      message: "Diet added successfully",
      body: { name, calories, protein, fat, fiber, type }
    });
  } catch (error) {
    console.error(error.message);
    res.status(500).json({ message: "Error adding diet", error: error.message });
  }
};

exports.getDiet = async (req, res) => {
  try {
    const diets = await Diet.find().select('-__v');
    res.json(diets);
  } catch (error) {
    console.error("Error fetching diets", error);
    res.status(500).json({ message: "Error fetching diets" });
  }
};
