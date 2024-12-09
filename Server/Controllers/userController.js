const User = require('../Models/User');
const { upload } = require('../Services/uploadService'); // Kiểm tra đường dẫn tới file upload
const port = "8080"

// Middleware tải lên hình ảnh
exports.uploadImage = upload.single('image'); // Thêm dòng này

// Lấy thông tin của người dùng hiện tại
exports.getCurrentUser = (req, res) => {
  res.status(200).json(req.user); // Gửi thông tin người dùng hiện tại
};

// Cập nhật thông tin của người dùng hiện tại
exports.updateCurrentUser = async (req, res) => {
  const userId = req.user._id; // Get ID from the authenticated user information
  const updateData = { ...req.body }; // Get the updated data from the request body

  // Kiểm tra nếu có hình ảnh đã được tải lên
  if (req.file) {
    updateData.image = `http://192.168.1.7:${port}/uploads/${req.file.filename}`; // Set the image path
  }

  try {
    // Update the user and return the updated document
    const updatedUser = await User.findByIdAndUpdate(userId, updateData, { new: true, select: '-__v' });

    if (!updatedUser) {
      return res.status(404).json({ message: 'User not found' });
    }

    // Return the updated user information without the __v field
    res.status(200).json({
      message: 'User updated successfully',
      user: updatedUser,
    });
  } catch (error) {
    res.status(500).json({ message: 'Error updating user', error: error });
  }
};

// Lấy thông tin của tất cả người dùng (chỉ admin)
exports.getAllUsers = async (req, res) => {
  try {
    
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const skip = (page - 1) * limit;

    const users = await User.find().select('-__v').skip(skip).limit(limit);
    
    const totalUsers = await User.countDocuments();

    if (users.length === 0) {
      return res.status(204).json({ message: 'No users found' });
    }

    res.status(200).json({
      message: 'Users retrieved successfully',
      data: users,
      total: totalUsers,
      currentPage: page,
      totalPages: Math.ceil(totalUsers / limit),
    });

  } catch (error) {
    console.error('Error retrieving users:', error); // Log the error for debugging
    res.status(500).json({ message: 'Error retrieving users', error: error.message });
  }
};


// Cập nhật thông tin người dùng theo ID (chỉ admin)
exports.updateUserById = async (req, res) => {
  const userId = req.params.id; // ID người dùng từ tham số

  try {
    const updatedUser = await User.findByIdAndUpdate(userId, req.body, { new: true, select: '-__v' });
    if (!updatedUser) {
      return res.status(404).json({ message: 'User not found' });
    }
    res.status(200).json({
      message: 'User updated successfully',
      user: updatedUser,
    });
  } catch (error) {
    res.status(500).json({ message: 'Error updating user', error: error });
  }
};

// Xóa người dùng (chỉ admin)
exports.deleteUserById = async (req, res) => {
  const userId = req.params.id; // ID người dùng từ tham số
  try {
    const deletedUser = await User.findByIdAndDelete(userId);
    if (!deletedUser) {
      return res.status(404).json({ message: 'User not found' });
    }
    res.status(200).json({ message: 'User deleted successfully' });
  } catch (error) {
    res.status(500).json({ message: 'Error deleting user', error: error });
  }
};
