const express = require('express');
const multer = require('multer');
const fs = require('fs');
const path = require('path');

const uploadDir = path.join(__dirname, '../uploads');

if (!fs.existsSync(uploadDir)) {
  fs.mkdirSync(uploadDir);
}

// Configure multer
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, uploadDir);
  },
  filename: (req, file, cb) => {
    cb(null, `${Date.now()}${path.extname(file.originalname)}`);
  },
});

// Create multer middlewares
const upload = multer({ storage: storage });

const setupUpload = (app) => {
  // Use the upload middleware for updating user info (including image)
  app.use('/uploads', express.static(uploadDir));
  app.post('/upload', upload.single('image'), (req, res) => {
    if (!req.file) {
      return res.status(400).send('No file uploaded.');
    }
    res.send(`File uploaded successfully: ${req.file.path}`);
  });
};

exports.uploadImage = upload.single('image');

module.exports = { setupUpload, upload };
