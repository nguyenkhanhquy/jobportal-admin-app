import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // Hàm xử lý thay đổi mật khẩu
  Future<void> changePassword() async {
    if (_formKey.currentState!.validate()) {
      if (_newPasswordController.text == _confirmPasswordController.text) {
        try {
          final fssToken = await FlutterSecureStorage().read(key: "token");
          if (fssToken == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Token không tồn tại. Vui lòng đăng nhập lại')),
            );
            return;
          }
          final response = await ApiService.changePassword(
            token: fssToken, // Thay thế bằng token từ secure storage
            currentPassword: _currentPasswordController.text,
            newPassword: _newPasswordController.text,
          );

          if (response['success']) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Đổi mật khẩu thành công'),
                  backgroundColor: Colors.green),
            );
            Navigator.pop(context); // Quay lại màn hình trước
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(response['message'])),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Đổi mật khẩu thất bại: $e')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Mật khẩu mới và xác nhận mật khẩu không khớp')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Đổi mật khẩu')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Mật khẩu hiện tại
              TextFormField(
                controller: _currentPasswordController,
                obscureText: false,
                decoration: InputDecoration(
                    labelText: 'Mật khẩu hiện tại',
                    border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mật khẩu hiện tại';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // Mật khẩu mới
              TextFormField(
                controller: _newPasswordController,
                obscureText: false,
                decoration: InputDecoration(
                    labelText: 'Mật khẩu mới', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mật khẩu mới';
                  }
                  if (value.length < 6) {
                    return 'Mật khẩu phải có ít nhất 6 ký tự';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // Xác nhận mật khẩu mới
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: false,
                decoration: InputDecoration(
                    labelText: 'Xác nhận mật khẩu',
                    border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng xác nhận mật khẩu';
                  }
                  if (value != _newPasswordController.text) {
                    return 'Mật khẩu xác nhận không khớp';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: changePassword,
                child: Text(
                  'Đổi mật khẩu',
                  style: TextStyle(color: Colors.white), // Màu chữ
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Màu nền
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5), // Bo góc
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12), // Padding
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
