const express = require('express');
const userController = require('../Controllers/loginController');
const router = express.Router();

// Route để đăng ký người dùng
router.post('/register', userController.register);

// Route để đăng nhập người dùng
router.post('/login', userController.login);

// Route để xác nhận mail 
router.get('/verify/:token', userController.getVerify);

// Route để gửi mail xác nhận mật khẩu
router.post('/fogetpass', userController.forget);


// Route để cập nhật mật khẩu mới
router.get('/reset-password/:token', userController.resetPassword);

module.exports = router;
