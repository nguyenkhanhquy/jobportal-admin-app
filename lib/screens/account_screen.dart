import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  final Map<String, dynamic> userData;

  AccountScreen({required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Thông tin tài khoản")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${userData['id']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            Text('Email: ${userData['email']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            Text('Ngày đăng ký: ${userData['registrationDate']}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            Text('Vai trò: ${userData['role']}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            Text(
                'Trạng thái: ${userData['active'] ? 'Hoạt động' : 'Không hoạt động'}',
                style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
