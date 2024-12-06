const express = require('express');
const userController = require('../Controllers/loginController');
const router = express.Router();

// Route để đăng ký người dùng
router.post('/register', userController.register);

// Route để đăng nhập người dùng
router.post('/login', userController.login);

router.get('/verify/:token', userController.getVerify);

module.exports = router;
