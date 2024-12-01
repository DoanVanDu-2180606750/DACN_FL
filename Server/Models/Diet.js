const mongoose = require('mongoose');

const dietSchema = new mongoose.Schema({
    name: { type: String, required: true, unique: true},
    water: { type: String, required: true, },
    protein: { type: String, required: true },
    powder: { type: String, required: true, },
    fat: { type: String, required: true },
    fiber: { type: String, required: true, },
    type: {type: Number, required: true,}, // Lưu ảnh dưới dạng buffer với loại nội dung
});

const Diet = mongoose.model('Diet', dietSchema);
module.exports = Diet;
