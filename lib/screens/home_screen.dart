import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/api_service.dart';
import 'login_screen.dart';
import 'account_screen.dart';
import 'change_password_screen.dart';
import '../widgets/common_snackbar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FlutterSecureStorage storage = FlutterSecureStorage();

  Future<void> logout() async {
    final token = await storage.read(key: "token");

    final response = await ApiService.logout(token: token);

    if (response['success']) {
      showCustomSnackbar(context, response['message'], Colors.green);

      await storage.delete(key: "token");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    } else {
      showCustomSnackbar(context, response['message'], Colors.red);
    }
  }

// Hàm gọi API để lấy thông tin người dùng
  Future<void> fetchUserInfo() async {
    final token = await storage.read(key: 'token'); // Lấy token từ storage

    if (token != null) {
      try {
        // Gọi API lấy thông tin người dùng
        final response = await ApiService.getUserInfo(token: token);

        // Nếu thành công, chuyển sang trang AccountScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AccountScreen(userData: response['result']),
          ),
        );
      } catch (e) {
        // Xử lý lỗi nếu có
        print('Error fetching user info: $e');
      }
    } else {
      // Nếu không có token
      print('Token not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Căn giữa theo chiều dọc
          children: [
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Căn giữa hàng
              children: [
                ElevatedButton.icon(
                  onPressed: (fetchUserInfo),
                  icon: Icon(Icons.account_circle_outlined),
                  label: Text("Tài khoản"),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.zero, // Bo tròn 0 để thành hình vuông
                    ),
                    padding: EdgeInsets.all(16),
                    minimumSize: Size(180, 60), // Đặt kích thước cố định
                  ),
                ),
                SizedBox(width: 16), // Khoảng cách giữa hai nút
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangePasswordScreen()),
                    );
                  },
                  icon: Icon(Icons.lock_outline), // Biểu tượng bên trái
                  label: Text("Đổi mật khẩu"), // Văn bản nút
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    padding: EdgeInsets.all(16),
                    minimumSize: Size(180, 60), // Đặt kích thước cố định
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Căn giữa hàng
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    print("Ứng viên button pressed");
                  },
                  icon: Icon(Icons.account_box_outlined), // Biểu tượng bên trái
                  label: Text("Ứng viên"),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    padding: EdgeInsets.all(16),
                    minimumSize: Size(180, 60), // Đặt kích thước cố định
                  ),
                ),
                SizedBox(width: 16), // Khoảng cách giữa hai nút
                ElevatedButton.icon(
                  onPressed: () {
                    print("Nhà tuyển dụng button pressed");
                  },
                  icon: Icon(Icons.apartment_rounded), // Biểu tượng bên trái
                  label: Text("Nhà tuyển dụng"),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    padding: EdgeInsets.all(16),
                    minimumSize: Size(180, 60), // Đặt kích thước cố định
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Căn giữa hàng
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    print("Danh sách bài đăng button pressed");
                  },
                  icon: Icon(Icons.menu_rounded), // Biểu tượng bên trái
                  label: Text("Bài đăng"),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    padding: EdgeInsets.all(16),
                    minimumSize: Size(180, 60), // Đặt kích thước cố định
                  ),
                ),
                SizedBox(width: 16), // Khoảng cách giữa hai nút

                ElevatedButton.icon(
                  onPressed: () {
                    print("Cài đặt button pressed");
                  },
                  icon: Icon(Icons.settings), // Biểu tượng bên trái
                  label: Text("Cài đặt"),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    //padding: EdgeInsets.all(16),
                    padding: EdgeInsets.all(16),
                    minimumSize: Size(180, 60),
                    // Đặt kích thước cố định
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: (logout),
              icon: Icon(Icons.logout_rounded), // Biểu tượng bên trái
              label: Text("Đăng xuất"),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                minimumSize: Size(370, 60),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
