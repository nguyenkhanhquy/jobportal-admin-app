import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/api_service.dart';

import 'home_screen.dart';
import '../widgets/common_snackbar.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FlutterSecureStorage storage = FlutterSecureStorage();
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    checkToken(); // Kiểm tra token ngay khi khởi tạo
  }

  Future<void> checkToken() async {
    final token = await storage.read(key: 'token'); // Đọc token từ storage

    if (token != null && token.isNotEmpty) {
      // Nếu token tồn tại, chuyển ngay sang HomeScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    }
    // Nếu không có token, giữ nguyên LoginScreen
  }

  Future<void> login() async {
    final response = await ApiService.login(
      email: emailController.text,
      password: passwordController.text,
    );

    if (response['success']) {
      await storage.write(key: "token", value: response['result']['token']);
      showCustomSnackbar(context, response['message'], Colors.green);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    } else {
      showCustomSnackbar(context, response['message'], Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30.0), // Bo góc logo
              child: Image.asset(
                'assets/logo.jpg', // Đường dẫn đến file ảnh trong thư mục assets
                height: 100, // Chiều cao logo
                width: 100, //
                fit: BoxFit.cover, // Cách ảnh hiển thị
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Ứng dụng quản lý", // Dòng chữ "Xin chào"
              style: TextStyle(
                fontSize: 20, // Kích thước chữ
                fontWeight: FontWeight.bold, // Đậm
                color: Colors.black, // Màu chữ (có thể thay đổi)
              ),
            ),
            Text(
              "Job Portal", // Dòng chữ "Xin chào"
              style: TextStyle(
                fontSize: 20, // Kích thước chữ
                fontWeight: FontWeight.bold, // Đậm
                color: Colors.black, // Màu chữ (có thể thay đổi)
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Email", // Ghi chú của trường nhập
                border: OutlineInputBorder(
                  // Đặt viền cho ô nhập
                  borderRadius:
                      BorderRadius.circular(12.0), // Bo góc cho ô nhập
                ),
                filled: true, // Đặt nền cho ô nhập
                fillColor: Color(0xFFF8F8F8),
                labelStyle: TextStyle(
                  color: Colors.black,
                ),
                focusedBorder: OutlineInputBorder(
                  // Viền khi ô nhập được chọn (focused)
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(
                    color: Colors
                        .green, // Màu xanh lá cây cho viền khi ô nhập được focus
                    width: 2.0, // Độ dày của viền
                  ),
                ),
                prefixIcon: Icon(
                  Icons.person, // Icon người dùng
                  color: Colors.grey, // Màu của icon
                ), // Màu nền cho ô nhập (màu xám nhạt)
                contentPadding: EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 10.0), // Padding cho nội dung
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: "Mật khẩu", // Ghi chú của trường nhập
                border: OutlineInputBorder(
                  // Đặt viền cho ô nhập
                  borderRadius:
                      BorderRadius.circular(12.0), // Bo góc cho ô nhập
                ),
                filled: true, // Đặt nền cho ô nhập
                fillColor: Color(0xFFF8F8F8),
                labelStyle: TextStyle(
                  color: Colors.black,
                ),
                focusedBorder: OutlineInputBorder(
                  // Viền khi ô nhập được chọn (focused)
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(
                    color: Colors
                        .green, // Màu xanh lá cây cho viền khi ô nhập được focus
                    width: 2.0, // Độ dày của viền
                  ),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility, // Đổi icon "mắt"
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible =
                          !_isPasswordVisible; // Thay đổi trạng thái ẩn/hiện mật khẩu
                    });
                  },
                ),
                prefixIcon: Icon(
                  Icons.lock, // Icon người dùng
                  color: Colors.grey, // Màu của icon
                ),
                // Màu nền cho ô nhập (màu xám nhạt)
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: login,
              child: Text("Đăng nhập"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF15B355),
                foregroundColor: Colors.white, // Màu nền (blue trong ví dụ này)
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0), // Bo góc cho nút
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
