const mongoose = require('mongoose');



const userSchema = new mongoose.Schema({
  
  name: {
    type: String,
  },
  email: {
    type: String,
    required: true,
    unique: true
  },
  password: {
    type: String,
    required: true
  },
  gender: {
    type: String,
    enum: ['male', 'female', 'other'],
  },
  address: {
    type: String,
  },
  phone: {
    type: String,
  },
  image: {
    type: String,
  },
  role: {
    type: String,
    enum: ['user', 'admin'], // Define possible roles
    default: 'user' // Default role
  },
    vToken: {
      type: String,
  },
}, { timestamps: true },
{ versionKey: false },
{ versionKey: '_somethingElse' });

userSchema.set('toJSON', {
  transform: (doc, ret) => {
    delete ret.__v; // Delete the __v field from the response
    return ret; // Return the modified object without __v
  },
});

module.exports = mongoose.model('User', userSchema);
