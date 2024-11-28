import 'package:fit_25/Model/User.dart';
import 'package:fit_25/Screen/EditProfile.dart';
import 'package:fit_25/Widgets/user_widget.dart';
import 'package:flutter/material.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  User user = User(
    name: UserName(title: "Mr.", first: "Đoàn", last: "Văn Dự"),
    email: "vdyla2020@example.com",
    gender: "Nam",
    phone: "0339455501",
    address: "39A, Gò Dưa, Tam Bình",
  );

  void _navigateToEditProfile() async {
    final updatedUser = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(user: user),
      ),
    );

    if (updatedUser != null) {
      setState(() {
        user = updatedUser as User;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thông Tin Cá Nhân')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 55,
              child: Text(user.name.first[0]),
            ),
            const SizedBox(height: 16),
            UserWidget.infoRow('Họ và Tên', '${user.name.first} ${user.name.last}'),
            UserWidget.infoRow('Email', user.email),
            UserWidget.infoRow('Giới tính', user.gender),
            UserWidget.infoRow('Số Điện Thoại', user.phone),
            UserWidget.infoRow('Địa chỉ', user.address),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _navigateToEditProfile,
              child: const Text('Sửa thông tin'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: (){},
              child: const Text('Đăng Xuất'),
            )
          ],
        ),
      ),
    );
  }
}
