const User = require('../Models/User');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

// Register a new user
exports.register = async (req, res) => {
    const { name, email, password, gender, address, phone, role } = req.body;
    try {
      // Check if the user already exists
      const existingUser = await User.findOne({ email });
      if (existingUser) {
        return res.status(400).json({ message: 'Email already exists' });
      }
      // Hash the password
      const hashedPassword = await bcrypt.hash(password, 10);
      // Create a new user
      const user = new User({ name, email, password: hashedPassword, gender, address, phone, role});
      await user.save();
  
      const token = jwt.sign({ id: user.id}, process.env.JWT_SECRET, { expiresIn: '1h' });
      
      res.status(201).json({
        message: 'User created successfully!',
        user: { id: user._id, name, email, gender, address, phone, role },
        token // Send JWT token
      });
      console.log('Đã thêm 1 user: ' + user.name);
    } catch (error) {
      console.error("Error saving user:", error);
      res.status(500).json({ message: 'Error registering user' });
    }
  };
  
  // Login a user
  exports.login = async (req, res) => {
    const { email, password } = req.body;
  
    try {
      // Find user by email
      const user = await User.findOne({ email });
      if (!user) {
        return res.status(401).json({ message: 'User not found' });
      }
      // Check password
      const match = await bcrypt.compare(password, user.password);
      if (!match) {
        return res.status(401).json({ message: 'Invalid password' });
      }
      if (user.vToken) {
        return res.status(200).json({ message: 'Login successful', user, token: user.vToken });;
      }
        const token = jwt.sign({id: user.id }, process.env.JWT_SECRET, { expiresIn: '2h' });
        return res.status(200).json({ message: 'Login successful', user, token });
    } catch (error) {
      console.error("Error during login:", error);
      res.status(500).json({ message: 'Server error' });
    }
  };
  // Update user information
// exports.updateUser = async (req, res) => {
//     const { id } = req.params;
//     const { name, email, gender, address, phone } = req.body;
//     let updateData = { name, email, gender, address, phone };
  
//     if (req.file) {
//       updateData.image = `http://localhost:${process.env.PORT}/uploads/${req.file.filename}`; // Update image if uploaded
//     }
  
//     try {
//       const updatedUser = await User.findByIdAndUpdate(id, updateData, { new: true, runValidators: true });
//       if (!updatedUser) {
//         return res.status(404).send({ message: "User not found" });
//       }
//       return res.status(200).json(updatedUser);
//     } catch (error) {
//       console.error("Error updating user:", error);
//       return res.status(400).send({ message: "Error updating user", error: error.message });
//     }
//   };