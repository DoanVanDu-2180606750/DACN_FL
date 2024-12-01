const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
    name: { type: String, required: true },
    email: { type: String, required: true, unique: true },
    password: { type: String, required: true },
    gender: { type: String, required: true },
    address: { type: String, required: true },
    phone: { type: String, required: true },
    image: {
        data: Buffer,
        contentType: String,
    }, // Lưu ảnh dưới dạng buffer với loại nội dung
});

const User = mongoose.model('User', userSchema);
module.exports = User;
