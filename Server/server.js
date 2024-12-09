const express = require('express');
const mongoose = require('mongoose');
const dotenv = require('dotenv');
const uploadService = require('./Services/uploadService'); 
dotenv.config();
const cors = require('cors');
const app = express();
const port = process.env.PORT;

// Middleware
app.use(express.json());
app.use(cors());
uploadService.setupUpload(app);

// Database Connection
const connectToDatabase = require('./Configs/db');
connectToDatabase();

app.use(cors({
  origin: ['http://127.0.0.1:5500'], // Array of allowed origins
  methods: 'GET, POST, PUT, DELETE', // Allow specific methods
  credentials: true // Allow cookies to be sent with requests
}));

// Routes
app.use('/api', require('./Routes/dietRoutes'));
app.use('/api', require('./Routes/userRoutes'));
app.use('/api', require('./Routes/loginRoutes'));

// Start server
app.listen(port, () => {
  console.log(`Server is running at http://192.168.1.7:${port}`);
});

app.get('/' , (req, res) => {
  res.send('Hello World!')
});

// Close connection on server close
process.on('SIGINT', async () => {
  await mongoose.connection.close();
  console.log("MongoDB connection closed");
  process.exit(0);
});