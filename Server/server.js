// Import các thư viện cần thiết
const express = require('express');
const mongoose = require('mongoose');
const multer = require('multer');
require('dotenv').config();
const { body, validationResult } = require('express-validator');
const bcrypt = require('bcrypt');
const app = express();
const path = require('path'); 
const Body = require('../Server/Models/Body');
const User = require('../Server/Models/User'); 
const Steps = require('../Server/Models/Steps');
const Diet = require('../Server/Models/Diet');
const port = process.env.PORT || 8080;
const saltRounds = 10;

app.use(express.json());

const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, 'DACN_FL/assets/Images/');
    },
    filename: (req, file, cb) => {
        cb(null, Date.now() + path.extname(file.originalname)); // Đổi tên file bằng thời gian hiện tại và đuôi mở rộng
    }
});

const upload = multer({ storage: storage }); // Định nghĩa middleware upload

// Hàm kết nối đến cơ sở dữ liệu MongoDB
const connectToDatabase = async () => {
    try {
        await mongoose.connect(process.env.MONGODB_URI, {
            useNewUrlParser: true,
            useUnifiedTopology: true
        });
        console.log("Đã kết nối tới MongoDB");
    } catch (error) {
        console.error("Lỗi kết nối đến MongoDB", error);
    }
};

connectToDatabase(); // Kết nối đến cơ sở dữ liệu

app.post('/api/post_diet', async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(422).json({ errors: errors.array() });
    }
    const { name, calo, water, protein, powder,fat, fiber, type } = req.body

    try {
        const diet = new Diet ({
            name,
            calo,
            water,
            protein,
            powder ,
            fat,
            fiber,
            type
        })
        await diet.save(),
        res.status(201).json({ 
            message: "Thêm thực phẩm thành công",
            data: {
                name: name,
                calo: calo,
                water: water,
                protein: protein,
                powder: powder,
                fat: fat,
                fiber: fiber,
                type: type
            }

        })

    } catch (error) {
        console.error(error.message);
    }
});

app.get('/api/get_diet', async (req, res) => {
    try {
        // const diets = await Diet.find().exec();
        const diets = await Diet.find().select('-__v'); 
        res.json(diets);
    } catch (error) {
        console.error("Lỗi lấy dữ liệu", error);
        res.status(500).json({ message: "Lỗi lấy dữ liệu" });
    }
});

app.post('/api/post_steps', async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(422).json({ errors: errors.array() });
    }

    const { currentSteps, runningSteps, targetSteps, elapsedTime } = req.body;
    try {
        const steps = new Steps({
            currentSteps,
            runningSteps,
            targetSteps,
            elapsedTime
            });
            await steps.save();
            res.json({ 
                message: "Tạo mới thành công",
                steps :{ 
                    currentSteps: currentSteps,
                    runningSteps: runningSteps,
                    targetSteps: targetSteps,
                    elapsedTime: elapsedTime,   
                }
            });
    } catch (error) {
        console.error("Lỗi tạo mới", error);
        res.status(500).json({ message: "Lỗi tạo mới" });
    }
});

app.get('/api/get_', async (req, res) => {
    try {
        const steps = await Steps.find().select('-__v'); 
        res.json(steps);
    } catch (error) {
        console.error("Lỗi lấy dữ liệu", error);
        res.status(500).json({ message: "Lỗi lấy dữ liệu" });
    }
});

app.post('/api/post_body', [
    body('weight').notEmpty().withMessage('Cân nặng là bắt buộc'),
    body('height').notEmpty().withMessage('Chiều cao là bắt buộc'),
    body('advice').notEmpty().withMessage('Lời khuyên là bắt buộc'), // Sửa thành 'advice'
], async (req, res) => {
    const errors = validationResult(req); // Kiểm tra lỗi validation
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() }); // Trả lỗi nếu có
    }

    const { weight, height, advice } = req.body; // Lấy dữ liệu từ request body

    try {
        const body = new Body({ // Tạo một instance mới của mô hình Body
            weight,
            height,
            advice,
        });
        await body.save(); // Lưu đối tượng vào cơ sở dữ liệu

        res.status(201).json({
            message: "Tạo thành công",
            body: {
                weight,
                height,
                advice,
            }
        });
    } catch (error) {
        console.error("Lỗi khi tạo dữ liệu:", error); // Log lỗi
        res.status(500).json({ message: "Lỗi tạo dữ liệu", error: error.message });
    }
});

app.get('/api/get_body', async (req, res) => {
    try {
        const body = await Body.find().select('-__v'); // Lấy tất cả dữ liệu từ cơ sở
        res.json(body);
    } catch (error) {
        console.error("Lỗi khi lấy dữ liệu:", error); // Log lỗi
        res.status(500).json({ 
            message: "Lỗi lấy dữ liệu", error: error
        });
    }
});

// Route thêm người dùng mới
app.post('/api/add_users', [
    body('name').notEmpty().withMessage('Tên là bắt buộc'),
    body('email').isEmail().withMessage('Định dạng email không hợp lệ'),
    body('password').isLength({ min: 8 }).withMessage('Mật khẩu phải có ít nhất 7 ký tự'),
    body('gender').notEmpty().withMessage('Giới tính là bắt buộc'),
    body('address').notEmpty().withMessage('Địa chỉ là bắt buộc'),
    body('phone').isMobilePhone().withMessage('Số điện thoại là không hợp lệ'),
], async (req, res) => {
    const errors = validationResult(req); // Kiểm tra lỗi validation
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() }); // Trả lỗi nếu có
    }
    const { name, email, password, gender, address, phone, image } = req.body;
    try {
        const hashedPassword = await bcrypt.hash(password, saltRounds); // Băm mật khẩu
        const user = new User({ 
            name, 
            email, 
            password: hashedPassword, 
            gender, 
            address, 
            phone, 
            image: image.filename // Lưu tên file ảnh
        });
        await user.save(); // Lưu người dùng vào cơ sở dữ liệu
        res.status(201).json({ 
            message: 'Người dùng đã được tạo thành công!', 
            user: { id: user._id, name: user.name, email: user.email, gender: user.gender, address: user.address, phone: user.phone, image: user.image }
        });
    } catch (error) {
        console.error("Lỗi lưu người dùng:", error); // Log lỗi
        res.status(500).json({ message: 'Lỗi khi lưu người dùng' });
    }
});

// Route lấy danh sách người dùng
app.get('/api/get_users', async (req, res) => {
    try {
        const users = await User.find().select('-__v -password'); // Lấy danh sách người dùng, bỏ qua các trường __v và password
        res.json(users);
    } catch (error) {
        console.error("Lỗi khi lấy người dùng:", error);
        res.status(500).json({ message: 'Lỗi khi lấy người dùng' });
    }
});

// Route cập nhật thông tin người dùng
app.put('/api/users/:id', upload.single('image'), async (req, res) => {
    const { id } = req.params; // Lấy ID từ URL
    const { name, email, gender, address, phone } = req.body;

    let updateData = { name, email, gender, address, phone };
    if (req.file) {
        updateData.image = req.file.path;  // Lưu đường dẫn đến ảnh mới
    }

    try {
        const updatedUser = await User.findByIdAndUpdate(id, updateData, { new: true, runValidators: true }); // Cập nhật người dùng
        if (!updatedUser) {
            return res.status(404).send({ message: "Không tìm thấy người dùng" });
        }
        console.log('Người dùng đã được cập nhật thành công:', updatedUser);
        return res.status(200).json(updatedUser);
    } catch (error) {
        console.error("Lỗi cập nhật người dùng: ", error);
        return res.status(400).send({ message: "Lỗi cập nhật người dùng", error: error.message });
    }
});

// Khởi động server và lắng nghe trên cổng đã chỉ định
app.listen(port, () => {
    console.log(`Server đang chạy tại http://localhost:${port}`);
});

// Đóng kết nối MongoDB khi server bị dừng
process.on('SIGINT', async () => {
    await mongoose.connection.close();
    console.log("Kết nối MongoDB đã được đóng");
    process.exit(0);
});



