const express = require('express');
const mongoose = require('mongoose');
// require('dotenv').config();
const User = require('../lib/Model/User');
const app = express();
const port = 8080;

// Middleware to parse JSON request bodies
app.use(express.json());

// Connect to MongoDB using Mongoose
const connectToDatabase = async () => {
    try {
        await mongoose.connect("mongodb+srv://vdyla2020:Vd21022003@cluster0.pcaeb.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0", {
            useNewUrlParser: true,
            useUnifiedTopology: true
        });
        console.log("Connected to MongoDB");
    } catch (error) {
        console.error("Error connecting to MongoDB", error);
    }
};

// Call the connect function
connectToDatabase();

//api add info user
app.post('/api/users', async (req, res) => {
    try {
        const { name, email, password, gender, address, phone } = req.body; // Destructure incoming JSON data
        const user = new User({ name, email, password, gender, address, phone }); // Create a new User instance
        await user.save(); // Save the user to the database
        res.status(201).json({ message: 'User created successfully!', user }); // Respond with success
    } catch (error) {
        console.error("Error adding user:", error);
        res.status(500).json({ message: 'Error adding user', error }); // Respond with an error
    }
});

app.get('/api/users',(req, res) => {
        const users = User.find().exec(); // Find all users in the database
});

// A sample route
app.get('/', (req, res) => {
    res.send('Hello World!');
});

// Start the server
app.listen(port, () => {
    console.log(`Server is running at http://localhost:${port}`);
});
