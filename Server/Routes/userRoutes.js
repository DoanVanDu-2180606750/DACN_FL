const express = require('express');
const { authorize, ROLES } = require('../Middlewares/authMiddleware');
const userController = require('../Controllers/userController');


const router = express.Router();

// Route để xem thông tin cá nhân 
router.get('/users/me', authorize([ROLES.USER, ROLES.ADMIN]), userController.getCurrentUser);

// Route để chỉnh sửa thông tin cá nhân (bao gồm tải lên hình ảnh)
router.put('/users/me', 
  authorize([ROLES.USER, ROLES.ADMIN]), 
    userController.uploadImage, // Thêm middleware để xử lý hình ảnh
    userController.updateCurrentUser
);

// Route để admin xem tất cả người dùng
router.get('/users', authorize([ROLES.ADMIN]), userController.getAllUsers);

// Route để admin chỉnh sửa bất kỳ người dùng nào
router.put('/users/:id', 
  authorize([ROLES.ADMIN]), 
  userController.updateUserById
);

// Route để admin xóa một người dùng
router.delete('/users/:id', 
  authorize([ROLES.ADMIN]), 
  userController.deleteUserById
);

module.exports = router;
