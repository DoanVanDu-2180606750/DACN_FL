const express = require('express');
const mongoose = require('mongoose');
const dotenv = require('dotenv');
const uploadService = require('./Services/uploadService'); 

dotenv.config();
const app = express();
const port = process.env.PORT || 8080;

// Middleware
app.use(express.json());
uploadService.setupUpload(app);

// Database Connection
const connectToDatabase = require('./Configs/db');
connectToDatabase();

// Routes
app.use('/api', require('./Routes/dietRoutes'));
// app.use('/api', require('./Routes/stepsRoutes'));
app.use('/api', require('./Routes/bodyRoutes'));
app.use('/api', require('./Routes/userRoutes'));
app.use('/api', require('./Routes/loginRoutes'));

// Start server
app.listen(port, () => {
  console.log(`Server is running at http://10.17.18.247:${port}`);
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
