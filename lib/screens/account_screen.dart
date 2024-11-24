import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AccountScreen extends StatelessWidget {
  final Map<String, dynamic> userData;

  AccountScreen({required this.userData});
// Định dạng ngày tháng năm
  String formatDate(String dateTimeString) {
    // Tách chuỗi bằng khoảng trắng
    List<String> parts =
        dateTimeString.split(' '); // ['21-11-2024', '19:05:59']
    return parts[0]; // Chỉ lấy phần ngày: '21-11-2024'
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 80.0),
            Center(
              child: Text(
                'Thông tin tài khoản',
                style: TextStyle(
                  fontSize: 30,
                  //color: Color(0xFF15B355),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(left: 20.0), // Thêm khoảng cách bên trái
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'ID: ', // Phần in đậm
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold, // In đậm
                        color: Colors.black, // Màu chữ
                      ),
                    ),
                    TextSpan(
                      text: '   ', // Khoảng cách (chuỗi khoảng trắng)
                      //style: TextStyle(fontSize: 18), // Kiểu chữ cho khoảng trắng
                    ),
                    TextSpan(
                      text: '${userData['id']}', // Phần giữ nguyên
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal, // Không in đậm
                        color: Colors.black, // Màu chữ
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(left: 20.0), // Thêm khoảng cách bên trái
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Email: ', // Phần in đậm
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold, // In đậm
                        color: Colors.black, // Màu chữ
                      ),
                    ),
                    TextSpan(
                      text: '   ', // Khoảng cách (chuỗi khoảng trắng)
                      //style: TextStyle(fontSize: 18), // Kiểu chữ cho khoảng trắng
                    ),
                    TextSpan(
                      text: '${userData['email']}', // Phần giữ nguyên
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal, // Không in đậm
                        color: Colors.black, // Màu chữ
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(left: 20.0), // Thêm khoảng cách bên trái
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Ngày đăng ký: ', // Phần in đậm
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold, // In đậm
                        color: Colors.black, // Màu chữ
                      ),
                    ),
                    TextSpan(
                      text: '   ', // Khoảng cách (chuỗi khoảng trắng)
                      //style: TextStyle(fontSize: 18), // Kiểu chữ cho khoảng trắng
                    ),
                    TextSpan(
                      text: formatDate(userData['registrationDate']),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal, // Không in đậm
                        color: Colors.black, // Màu chữ
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(left: 20.0), // Thêm khoảng cách bên trái
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Vai trò: ', // Phần in đậm
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold, // In đậm
                        color: Colors.black, // Màu chữ
                      ),
                    ),
                    TextSpan(
                      text: '   ', // Khoảng cách (chuỗi khoảng trắng)
                      //style: TextStyle(fontSize: 18), // Kiểu chữ cho khoảng trắng
                    ),
                    TextSpan(
                      text: '${userData['role']}', // Phần giữ nguyên
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal, // Không in đậm
                        color: Colors.black, // Màu chữ
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(left: 20.0), // Thêm khoảng cách bên trái
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Trạng thái hoạt động: ', // Phần in đậm
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold, // In đậm
                        color: Colors.black, // Màu chữ
                      ),
                    ),
                    TextSpan(
                      text: '   ', // Khoảng cách (chuỗi khoảng trắng)
                      //style: TextStyle(fontSize: 18), // Kiểu chữ cho khoảng trắng
                    ),
                    TextSpan(
                      text: userData['active']
                          ? 'Hoạt động'
                          : 'Không hoạt động', // Phần giữ nguyên
                      style: TextStyle(
                        fontSize: 18,
                        color: userData['active'] ? Colors.green : Colors.red,
                        fontWeight: FontWeight.normal, // Không in đậm
                        // color: Colors.black, // Màu chữ
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
