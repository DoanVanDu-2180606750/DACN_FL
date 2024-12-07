const User = require('../Models/User');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

const {sendEmail} = require('../Services/emailService')


// Đăng ký người dùng mới
exports.register = async (req, res) => {
    const { name, email, password} = req.body;

    try {
      const existingUser = await User.findOne({ email });
      if (existingUser) {
        return res.status(400).json({ message: 'Email already exists' });
      }

      // Hash the password
      const hashedPassword = await bcrypt.hash(password, 10);
      const user = new User({ name, email, password: hashedPassword});
      await user.save();

      // Tạo mã xác thực
      const verificationToken = jwt.sign({ id: user.id }, process.env.JWT_SECRET, { expiresIn: '1h' });

      // Tạo đường dẫn xác thực
      const verificationUrl = `http://192.168.1.7:${process.env.PORT}/api/verify/${verificationToken}`; // Địa chỉ trang reset mật khẩu

      // Gửi email với liên kết đặt lại mật khẩu
      const emailContent = `Vui lòng nhấp vào đường dẫn dưới đây để xác thực email của bạn: ${verificationUrl}`;

      await sendEmail(email, 'Xác thực email của bạn', emailContent);
      res.status(201).json({
        message: 'User created successfully! Vui lòng kiểm tra email để xác thực.',
        user: { id: user._id, name, email}
      });
      console.log('Đã thêm user: ' + user.name);
    } catch (error) {
      console.error("Error saving user:", error);
      res.status(500).json({ message: 'Error registering user' });
    }
};

// Xác thực email
exports.getVerify = async (req, res) => {
  const { token } = req.params;
  if (!token) {
    return res.status(400).send('Không tìm thấy token.'); // Xử lý khi không có token
  }
  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    const userId = decoded.id; // Chỉnh sửa key thành userId

    // Cập nhật trạng thái người dùng là đã được xác thực
    await User.findByIdAndUpdate(userId, { isVerified: true });

    return res.status(200).send('Xác thực thành công! Bạn có thể đăng nhập.'),
    console.log("Xác thực thành công!#!");
  } catch (error) {
    console.error('Lỗi xác thực token:', error);
    return res.status(400).send('Token không hợp lệ hoặc đã hết hạn.');
  }
};

// Quên mật khẩu
exports.forget = async (req, res) => {
    const { email, newPassword } = req.body;

    try {
        const user = await User.findOne({ email });
        if (!user) {
            return res.status(400).json({ message: 'Email không tồn tại.' });
        }

        // Tạo token reset mật khẩu
        const resetToken = jwt.sign({ id: user.id }, process.env.JWT_SECRET, { expiresIn: '1h' });

        // Tạo đường dẫn xác nhận thay đổi mật khẩu
        const resetUrl = `http://192.168.1.7:${process.env.PORT}/api/reset-password/${resetToken}?email=${email}&newPassword=${newPassword}`;

        // Gửi email với liên kết thay đổi mật khẩu
        const emailContent = `Nhấp vào đây để đổi mật khẩu: ${resetUrl}`;

        await sendEmail(email, 'Xác nhận thay đổi mật khẩu', emailContent);

        res.status(200).json({ message: 'Email đã được gửi! Vui lòng kiểm tra hộp thư của bạn.' });
    } catch (error) {
        console.error("Có lỗi xảy ra khi yêu cầu thay đổi mật khẩu:", error);
        res.status(500).json({ message: 'Có lỗi xảy ra, xin hãy thử lại sau.' });
    }
};

// Đặt lại mật khẩu
exports.resetPassword = async (req, res) => {
    const { token } = req.params;
    const { newPassword } = req.query;

    try {
        // Giải mã token
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        const userId = decoded.id;

        // Tìm người dùng và cập nhật mật khẩu
        const hashedPassword = await bcrypt.hash(newPassword, 10);
        await User.findByIdAndUpdate(userId, { password: hashedPassword });

        res.status(200).json({ message: 'Mật khẩu đã được cập nhật thành công!' });
    } catch (error) {
        console.error('Lỗi trong quá trình đặt lại mật khẩu:', error);
        res.status(400).json({ message: 'Token không hợp lệ hoặc đã hết hạn.' });
    }
};


// Đăng nhập người dùng
exports.login = async (req, res) => {
  const { email, password } = req.body;

  try {
      const user = await User.findOne({ email });
      if (!user) {
          return res.status(401).json({ message: 'User not found' });
      }

      const match = await bcrypt.compare(password, user.password);
      if (!match) {
          return res.status(401).json({ message: 'Invalid password' });
      }

      // Lấy giá trị isVerified từ user
      const isVerified = user.isVerified; // Kiểm tra trạng thái xác thực

      // Sử dụng trạng thái isVerified để phản hồi
      if (!isVerified) {
          return res.status(401).json({ message: 'Tài khoản chưa được xác thực.' });
      }

      // Nếu tất cả điều kiện đều đúng, tạo token và đăng nhập thành công
      const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET, { expiresIn: '2h' });
      return res.status(200).json({ message: 'Đăng nhập thành công', user, token });
    } catch (error) {
        console.error("Lỗi đăng nhập:", error);
        res.status(500).json({ message: 'Lỗi máy chủ' });
    }
 };
