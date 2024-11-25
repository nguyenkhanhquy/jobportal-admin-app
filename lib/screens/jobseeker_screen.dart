import 'package:flutter/material.dart';
import 'dart:convert';

class JobseekerScreen extends StatelessWidget {
  var jobseekerData;

  JobseekerScreen({required this.jobseekerData});
// Định dạng ngày tháng năm
  String formatDate(String dateTimeString) {
    // Tách chuỗi bằng khoảng trắng
    List<String> parts =
        dateTimeString.split(' '); // ['21-11-2024', '19:05:59']
    return parts[0]; // Chỉ lấy phần ngày: '21-11-2024'
  }

  void _showDetailsDialog(
      BuildContext context, Map<String, dynamic> jobseeker) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Thông tin chi tiết"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "ID: ",
                        style: TextStyle(fontWeight: FontWeight.bold), // In đậm
                      ),
                      TextSpan(
                        text: jobseeker['id'], // Nội dung giá trị
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Email: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: jobseeker['email'],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Họ tên: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: utf8.decode(
                            jobseeker['fullName'].toString().runes.toList()),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Ngày đăng ký: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: jobseeker['registrationDate'] != null
                            ? utf8.decode(jobseeker['registrationDate']
                                .toString()
                                .runes
                                .toList())
                            : 'Chưa cập nhật',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Ngày sinh: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: jobseeker['dob'] != null
                            ? utf8.decode(
                                jobseeker['dob'].toString().runes.toList())
                            : 'Chưa cập nhật',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Số điện thoại: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: jobseeker['phone'] != null
                            ? utf8.decode(
                                jobseeker['phone'].toString().runes.toList())
                            : 'Chưa cập nhật',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Địa chỉ: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: jobseeker['address'] != null
                            ? utf8.decode(
                                jobseeker['address'].toString().runes.toList())
                            : 'Chưa cập nhật',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Kinh nghiệm: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: jobseeker['workExperience'] != null
                            ? utf8.decode(jobseeker['workExperience']
                                .toString()
                                .runes
                                .toList())
                            : 'Chưa cập nhật',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Trạng thái hoạt động: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: jobseeker['active'] != null
                            ? utf8.decode(
                                jobseeker['active'].toString().runes.toList())
                            : 'Chưa cập nhật',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Trạng thái hoạt động: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: jobseeker['locked'] != null
                            ? (jobseeker['locked']
                                ? 'Đã bị khóa' // Nếu 'locked' là true
                                : 'Bình thường') // Nếu 'locked' là false
                            : 'Chưa cập nhật', // Nếu 'locked' không có giá trị
                        style: TextStyle(
                          color: jobseeker['locked'] != null
                              ? (jobseeker['locked']
                                  ? Colors.red // Màu đỏ khi bị khóa
                                  : Colors.green) // Màu xanh khi bình thường
                              : Colors.grey, // Màu xám nếu không có thông tin
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    // Xử lý sự kiện khi nhấn nút (vd: khóa/mở khóa người dùng)
                    if (jobseeker['locked'] == true) {
                      // Thực hiện mở khóa
                      print("Mở khóa người dùng");
                    } else {
                      // Thực hiện khóa
                      print("Khóa người dùng");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        jobseeker['locked'] == true ? Colors.green : Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5), // Bo góc viền
                    ),
                  ),
                  child: Text(
                    jobseeker['locked'] == true ? "Mở Khóa" : "Khóa",
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                // Tương tự cho các trường khác
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: Text("Đóng"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quản lý tài khoản ứng viên')),
      body: ListView.builder(
        itemCount: jobseekerData.length,
        itemBuilder: (context, index) {
          final user = jobseekerData[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: user['locked'] ? Colors.red : Colors.green, // Màu viền
                width: 1,
              ),
            ),
            elevation: 2,
            color:
                user['locked'] ? Colors.red[100] : Colors.green[100], // Màu nền
            child: Container(
              width: 350, // Chiều rộng cố định
              height: 100, // Chiều cao cố định
              child: ListTile(
                title: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Căn trái cho tên và email
                  children: [
                    Text(
                      user['email'] ?? "Không có email",
                      style: TextStyle(
                        fontSize: 16, // Kích thước font chữ
                      ),
                    ),
                    SizedBox(height: 4), // Khoảng cách giữa email và tên
                    Text(
                      utf8.decode(user['fullName'].toString().runes.toList()),
                      style: TextStyle(
                        fontSize: 14, // Kích thước chữ của tên
                        color: Colors.grey[600], // Màu chữ tên
                      ),
                    ),
                    SizedBox(height: 4), // Khoảng cách giữa email và tên
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text:
                                'Trạng thái: ', // Phần đầu của câu, không tô đậm
                            style: TextStyle(
                              fontSize: 14, // Kích thước chữ
                              color: Colors.grey[600], // Màu chữ
                            ),
                          ),
                          TextSpan(
                            text: user['locked'] == true
                                ? 'Đã bị khóa' // Nếu khóa
                                : 'Bình thường', // Nếu không khóa
                            style: TextStyle(
                                fontSize: 14, // Kích thước chữ
                                fontWeight: FontWeight.bold, // Tô đậm chữ
                                color: user['locked'] == true
                                    ? Color(0xFFAB2328)
                                    : Color(0xFF006E33)),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                onTap: () => _showDetailsDialog(context, user),
                trailing: Icon(
                  user['locked'] ? Icons.lock : Icons.lock_open,
                  color: user['locked'] ? Colors.red : Colors.green,
                  size: 30, // Kích thước icon
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
