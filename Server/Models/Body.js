const mongoose = require('mongoose');

const BodySchema = new mongoose.Schema({
    weight: { type: Number, required: true },
    height: { type: Number, required: true },
    advice: { type: String, required: true },
}, { timestamps: true });

const Body = mongoose.model('Body', BodySchema);
module.exports = Body;
