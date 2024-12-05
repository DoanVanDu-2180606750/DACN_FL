import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:fit_25/Model/user_mode.dart';
import 'package:fit_25/Providers/loginProvider.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final User user;

  const ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _genderController;
  File? _image; // Lưu trữ ảnh đã chọn
  bool _isLoading = false; // Quản lý trạng thái loading

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phone);
    _addressController = TextEditingController(text: widget.user.address);
    _genderController = TextEditingController(text: widget.user.gender);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      print("Image path: ${image.path}"); // Ghi log đường dẫn hình ảnh
      setState(() {
        _image = File(image.path); // Cập nhật trạng thái với hình ảnh đã chọn
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Chưa chọn ảnh.')),
      );
    }
  }

  Future<void> _putProfile() async {
    setState(() {
      _isLoading = true; // Hiện spinner loading
    });

    try {
      final userToken = Provider.of<UserProvider>(context, listen: false).token;
      final requestUrl = 'http://10.17.18.247:8080/api/users/me';
      
      var request = http.MultipartRequest('PUT', Uri.parse(requestUrl));

      // Thêm headers
      request.headers['Authorization'] = 'Bearer $userToken';
      // Không cần Content-Type, nó sẽ được thiết lập tự động khi chuyển đa phần

      // Thêm các trường dữ liệu
      request.fields['name'] = _nameController.text.isNotEmpty ? _nameController.text : 'N/A';
      request.fields['email'] = _emailController.text.isNotEmpty ? _emailController.text : '';
      request.fields['phone'] = _phoneController.text.isNotEmpty ? _phoneController.text : '';
      request.fields['address'] = _addressController.text.isNotEmpty ? _addressController.text : '';
      request.fields['gender'] = _genderController.text.isNotEmpty ? _genderController.text : '';

      // Thêm hình ảnh nếu có
      if (_image != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image', // Tên trường hình ảnh trong API
          _image!.path,
          filename: _image!.path.split('/').last // Chỉ lấy tên file
        ));
      }

      // Gửi yêu cầu và nhận phản hồi
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cập nhật thông tin thành công')),
        );
      } else {
        // Xử lý phản hồi lỗi
        final errorMsg = jsonDecode(response.body)['message'] ?? 'Đã có lỗi xảy ra';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg)),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cập nhật thông tin thất bại: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Ẩn spinner loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chỉnh sửa thông tin')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              if (_image != null && _image!.existsSync())
                Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: FileImage(_image!), // Hiển thị hình ảnh đã chọn
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else
                const Icon(Icons.person, size: 100), // Biểu tượng mặc định nếu chưa có ảnh
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Chọn ảnh từ thư mục'),
              ),
              _buildTextInput(_nameController, 'Họ và Tên'),
              _buildTextInput(_emailController, 'Email'),
              _buildTextInput(_phoneController, 'Số Điện Thoại'),
              _buildTextInput(_addressController, 'Địa chỉ'),
              _buildTextInput(_genderController, 'Giới tính'),
              const SizedBox(height: 20),
              if (_isLoading) const CircularProgressIndicator(), // Hiện chỉ báo loading
              if (!_isLoading)
                ElevatedButton(
                  onPressed: _putProfile,
                  child: const Text('Lưu'),
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextInput(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: TextInputType.text,
    );
  }
}
