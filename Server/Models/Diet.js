const mongoose = require('mongoose');

const dietSchema = new mongoose.Schema({
    name: { type: String, required: true, unique: true },
    calories: { type: String, required: true },
    protein: { type: String, required: true },
    fat: { type: String, required: true },
    fiber: { type: String, required: true },
    type: { type: Number, required: true },
});

const Diet = mongoose.model('Diet', dietSchema);
module.exports = Diet;
