import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/api_service.dart';
import 'login_screen.dart';
import 'account_screen.dart';
import 'change_password_screen.dart';
import '../widgets/common_snackbar.dart';

var overviewData;

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
        print('Hello, world!');
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

  // Hàm gọi API để lấy thông tin tổng quan
  Future<void> fetchOverview() async {
    final token = await storage.read(key: 'token'); // Lấy token từ storage

    if (token != null) {
      try {
        // Gọi API lấy thông tin người dùng
        final response = await ApiService.getOverview(token: token);

        overviewData = response['result'];
        print(overviewData['totalJobSeekers']);
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
  void initState() {
    super.initState();
    // Gọi fetchOverview ngay khi trang được khởi tạo
    fetchOverview();
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
            Padding(
              padding:
                  EdgeInsets.only(left: 30), // Thêm khoảng cách từ cạnh trái
              child: Align(
                alignment: Alignment.centerLeft, // Căn phần tử sang trái
                child: Text(
                  "Tổng quan",
                  //overviewData['totalJobSeekers'];
                  style: TextStyle(
                    fontSize: 26, // Tăng cỡ chữ
                    //fontWeight: FontWeight.bold, // In đậm nếu cần
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Căn giữa hàng
              children: [
                Container(
                  height: 100, // Chiều cao của ô
                  width: 180, // Chiều rộng của ô
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0x2000AEEF), // Màu nền cho ô
                    borderRadius: BorderRadius.circular(8), // Bo góc cho ô
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons
                            .supervised_user_circle_outlined, // Chọn biểu tượng bạn muốn
                        color: Colors.black, // Màu icon
                        size: 40.0,
                      ),
                      SizedBox(width: 20), // Khoảng cách giữa icon và text
                      Text(
                        '           ${overviewData['totalJobSeekers']}\n    Ứng viên', // Thay bằng dữ liệu bạn muốn hiển thị
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black, // Màu chữ trắng
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                Container(
                  height: 100, // Chiều cao của ô
                  width: 180, // Chiều rộng của ô
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0x2008FF08), // Màu nền cho ô
                    borderRadius: BorderRadius.circular(8), // Bo góc cho ô
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons
                            .switch_account_rounded, // Chọn biểu tượng bạn muốn
                        color: Colors.black, // Màu icon
                        size: 40.0,
                      ),
                      SizedBox(width: 8), // Khoảng cách giữa icon và text
                      Text(
                        '            ${overviewData['totalRecruiters']}\n Nhà tuyển dụng', // Thay bằng dữ liệu bạn muốn hiển thị
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black, // Màu chữ trắng
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ), // Khoảng cách giữa hai nút
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Căn giữa hàng
              children: [
                Container(
                  height: 100, // Chiều cao của ô
                  width: 180, // Chiều rộng của ô
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0x20fdb813), // Màu nền cho ô
                    borderRadius: BorderRadius.circular(8), // Bo góc cho ô
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons
                            .sticky_note_2_outlined, // Chọn biểu tượng bạn muốn
                        color: Colors.black, // Màu icon
                        size: 40.0,
                      ),
                      SizedBox(width: 8), // Khoảng cách giữa icon và text
                      Text(
                        '            ${overviewData['totalJobPosts']}\n       Bài đăng', // Thay bằng dữ liệu bạn muốn hiển thị
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black, // Màu chữ trắng
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                Container(
                  height: 100, // Chiều cao của ô
                  width: 180, // Chiều rộng của ô
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0x20E10600), // Màu nền cho ô
                    borderRadius: BorderRadius.circular(8), // Bo góc cho ô
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.folder_copy_rounded, // Chọn biểu tượng bạn muốn
                        color: Colors.black, // Màu icon
                        size: 40.0,
                      ),
                      SizedBox(width: 8), // Khoảng cách giữa icon và text
                      Text(
                        '            ${overviewData['totalJobApplies']}\n   Đơn ứng tuyển', // Thay bằng dữ liệu bạn muốn hiển thị
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black, // Màu chữ trắng
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ), // Khoảng cách giữa hai nút
              ],
            ),
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
