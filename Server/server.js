const express = require('express');
const mongoose = require('mongoose');
const multer = require('multer');
require('dotenv').config();
const User = require('../Server/Models/User');
const { body, validationResult } = require('express-validator');
const bcrypt = require('bcrypt');
const app = express();
const port = process.env.PORT || 8080;
const saltRounds = 10;

app.use(express.json());

const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, 'uploads/'); // Specify the upload directory
    },
    filename: (req, file, cb) => {
        cb(null, Date.now() + path.extname(file.originalname)); // Rename file
    }
});

const upload = multer({ storage: storage }); // Define upload middleware

const connectToDatabase = async () => {
    try {
        await mongoose.connect(process.env.MONGODB_URI, {
            useNewUrlParser: true,
            useUnifiedTopology: true
        });
        console.log("Connected to MongoDB");
    } catch (error) {
        console.error("Error connecting to MongoDB", error);
    }
};

connectToDatabase();

app.post('/api/add_users', [
    body('name').notEmpty().withMessage('Name is required'),
    body('email').isEmail().withMessage('Invalid email format'),
    body('password').isLength({ min: 6 }).withMessage('Password must be at least 6 characters'),
    body('gender').notEmpty().withMessage('Gender is required'),
    body('address').notEmpty().withMessage('Address is required'),
    body('phone').notEmpty().withMessage('Phone is required'),
], async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }

    const { name, email, password, gender, address, phone, image } = req.body;

    try {
        const hashedPassword = await bcrypt.hash(password, saltRounds);
        const user = new User({ name, email, password: hashedPassword, gender, address, phone, image });

        await user.save();
        res.status(201).json({ 
            message: 'User created successfully!', 
            user: { id: user._id, name: user.name, email: user.email, gender: user.gender, address: user.address, phone: user.phone, image: user.image }
        });
    } catch (error) {
        console.error("Error saving user:", error);
        res.status(500).json({ message: 'Error saving user' });
    }
});

app.get('/api/get_users', async (req, res) => {
    try {
        const users = await User.find().select('-__v -password');
        res.json(users);
    } catch (error) {
        console.error("Error fetching users:", error);
        res.status(500).json({ message: 'Error fetching users' });
    }
});

app.put('/api/users/:id', upload.single('image'), async (req, res) => {
    const { id } = req.params;
    const { name, email, gender, address, phone } = req.body;

    let updateData = { name, email, gender, address, phone };
    if (req.file) {
        updateData.image = req.file.path;  // Save the path to the new image
    }

    try {
        const updatedUser = await User.findByIdAndUpdate(id, updateData, { new: true, runValidators: true });
        if (!updatedUser) {
            return res.status(404).send({ message: "User not found" });
        }
        console.log('User updated successfully:', updatedUser);
        return res.status(200).json(updatedUser);
    } catch (error) {
        console.error("Error updating user: ", error);
        return res.status(400).send({ message: "Error updating user", error: error.message });
    }
});



app.listen(port, () => {
    console.log(`Server is running at http://localhost:${port}`);
});

process.on('SIGINT', async () => {
    await mongoose.connection.close();
    console.log("MongoDB connection closed");
    process.exit(0);
});
