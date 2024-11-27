import 'package:flutter/material.dart';

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
            Container(
              margin: EdgeInsets.all(20.0), // Khoảng cách ngoài khung
              padding: EdgeInsets.all(15.0), // Khoảng cách bên trong khung
              decoration: BoxDecoration(
                color: Colors.white, // Màu nền của khung
                borderRadius: BorderRadius.circular(10.0), // Bo góc khung
                border:
                    Border.all(color: Colors.grey, width: 1.0), // Viền khung
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Màu bóng đổ
                    spreadRadius: 2, // Độ lan của bóng
                    blurRadius: 5, // Độ mờ của bóng
                    offset: Offset(0, 3), // Vị trí bóng (x, y)
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Căn nội dung về bên trái
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                        top: 5.0), // Thêm khoảng cách bên trái
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'ID: ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: '${userData['id']}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Email: ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: '${userData['email']}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Ngày tạo: ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: formatDate(userData['registrationDate']),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Vai trò: ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: '${userData['role']}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Trạng thái hoạt động: ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: userData['active']
                                ? 'Hoạt động'
                                : 'Không hoạt động',
                            style: TextStyle(
                              fontSize: 18,
                              color: userData['active']
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
