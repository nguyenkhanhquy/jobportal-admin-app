import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';

class JobPostsScreen extends StatefulWidget {
  final List<dynamic>? jobPosts;

  JobPostsScreen({required this.jobPosts});

  @override
  _JobPostsScreenState createState() => _JobPostsScreenState();
}

class _JobPostsScreenState extends State<JobPostsScreen> {
  late List<dynamic> _jobPosts;

  @override
  void initState() {
    super.initState();
    _jobPosts = widget.jobPosts ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Danh sách bài đăng"),
      ),
      body:
          //? Center(child: CircularProgressIndicator())
          ListView.builder(
        itemCount: _jobPosts.length,
        itemBuilder: (context, index) {
          final jobPost = _jobPosts[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            elevation: 1,
            child: Container(
              decoration: BoxDecoration(
                color: jobPost['hidden'] == false
                    ? Colors.green[100]
                    : Colors.grey[
                        400], // Nền xanh khi hide == false, xám khi hide == true
                border: Border.all(
                  color: jobPost['hidden'] == false
                      ? Colors.green
                      : Colors
                          .grey, // Viền xanh khi hide == false, xám khi hide == true
                  width: 2, // Độ rộng viền
                ),
                borderRadius: BorderRadius.circular(8), // Bo tròn góc cho viền
              ),
              child: ListTile(
                title: Text(
                  utf8.decode(jobPost['title'].runes.toList()),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4),
                    // Label và Text cùng dòng - Công ty
                    Row(
                      children: [
                        Text(
                          "Công ty: ",
                          style: TextStyle(
                              fontWeight:
                                  FontWeight.bold), // Tô đậm label "Công ty"
                        ),
                        Expanded(
                          child: Text(
                            utf8.decode(
                                jobPost['company']['name'].runes.toList()),
                            overflow:
                                TextOverflow.ellipsis, // Đảm bảo không bị tràn
                          ),
                        ),
                      ],
                    ),
                    // Label và Text cùng dòng - Vị trí
                    Row(
                      children: [
                        Text(
                          "Vị trí: ",
                          style: TextStyle(
                              fontWeight:
                                  FontWeight.bold), // Tô đậm label "Vị trí"
                        ),
                        Expanded(
                          child: Text(
                            utf8.decode(jobPost['jobPosition'].runes.toList()),
                            overflow:
                                TextOverflow.ellipsis, // Đảm bảo không bị tràn
                          ),
                        ),
                      ],
                    ),
                    // Label và Text cùng dòng - Ngày đăng
                    Row(
                      children: [
                        Text(
                          "Ngày đăng: ",
                          style: TextStyle(
                              fontWeight:
                                  FontWeight.bold), // Tô đậm label "Ngày đăng"
                        ),
                        Expanded(
                          child: Text(
                            jobPost['createdDate'],
                            overflow:
                                TextOverflow.ellipsis, // Đảm bảo không bị tràn
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                leading: Icon(Icons.work_outline, color: Colors.black),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          JobPostDetailScreen(jobPost: jobPost),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class JobPostDetailScreen extends StatelessWidget {
  final Map<String, dynamic> jobPost;

  JobPostDetailScreen({required this.jobPost});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Chi tiết bài đăng'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Căn giữa
                  children: [
                    Expanded(
                      // Đảm bảo Text không bị tràn
                      child: Text(
                        utf8.decode(jobPost['title'].runes.toList()),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF046A38), // Màu xanh cho title
                        ),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                    SizedBox(width: 10),
                    // Nút ẩn/hiện
                    ElevatedButton(
                      onPressed: () {
                        // Thực hiện hành động khi nhấn nút
                        // Ví dụ: thực hiện hành động ẩn/hiện bài đăng
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              5), // Bo góc với bán kính là 5
                        ),
                        backgroundColor: jobPost['hidden']
                            ? Colors.green
                            : Colors.black.withOpacity(0.5), // Màu nền nút
                      ),
                      child: Text(
                        jobPost['hidden'] ? 'HIỆN' : 'ẨN', // Chữ trên nút
                        style: TextStyle(
                          color: Colors.white, // Màu chữ nút
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  "Công ty: ${utf8.decode(jobPost['company']['name'].runes.toList())}",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8),
                Divider(
                  color: Colors.grey, // Đặt màu cho đường kẻ
                  thickness: 1, // Độ dày của đường kẻ
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      "Vị trí tuyển dụng: ",
                      style: TextStyle(
                          fontWeight:
                              FontWeight.bold), // Tô đậm label "Ngày đăng"
                    ),
                    Expanded(
                      child: Text(
                        utf8.decode(jobPost['jobPosition'].runes.toList()),
                        overflow:
                            TextOverflow.ellipsis, // Đảm bảo không bị tràn
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      "Mức lương: ",
                      style: TextStyle(
                          fontWeight:
                              FontWeight.bold), // Tô đậm label "Ngày đăng"
                    ),
                    Expanded(
                      child: Text(
                        utf8.decode(jobPost['salary'].runes.toList()),
                        overflow:
                            TextOverflow.ellipsis, // Đảm bảo không bị tràn
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      "Số lượng tuyển dụng: ",
                      style: TextStyle(
                          fontWeight:
                              FontWeight.bold), // Tô đậm label "Ngày đăng"
                    ),
                    Expanded(
                      child: Text(
                        NumberFormat('#,###').format(jobPost['quantity']),
                        overflow:
                            TextOverflow.ellipsis, // Đảm bảo không bị tràn
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      "Loại hợp đồng: ",
                      style: TextStyle(
                          fontWeight:
                              FontWeight.bold), // Tô đậm label "Ngày đăng"
                    ),
                    Expanded(
                      child: Text(
                        utf8.decode(jobPost['type'].runes.toList()),
                        overflow:
                            TextOverflow.ellipsis, // Đảm bảo không bị tràn
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      "Hình thức làm việc: ",
                      style: TextStyle(
                          fontWeight:
                              FontWeight.bold), // Tô đậm label "Ngày đăng"
                    ),
                    Expanded(
                      child: Text(
                        utf8.decode(jobPost['remote'].runes.toList()),
                        overflow:
                            TextOverflow.ellipsis, // Đảm bảo không bị tràn
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  "Địa chỉ làm việc: ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold), // Tô đậm label "Ngày đăng"
                ),
                Text(
                  utf8.decode(jobPost['address'].runes.toList()),
                  //overflow: TextOverflow.ellipsis, // Đảm bảo không bị tràn
                ),
                SizedBox(height: 8),
                Divider(
                  color: Colors.grey, // Đặt màu cho đường kẻ
                  thickness: 1, // Độ dày của đường kẻ
                ),
                SizedBox(height: 8),
                Text(
                  "Mô tả công việc: ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold), // Tô đậm label "Ngày đăng"
                ),
                Text(
                  utf8.decode(jobPost['description'].runes.toList()),
                  //overflow: TextOverflow.ellipsis, // Đảm bảo không bị tràn
                ),
                SizedBox(height: 20),
                Text(
                  "Yêu cầu ứng viên: ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold), // Tô đậm label "Ngày đăng"
                ),
                Text(
                  utf8.decode(jobPost['requirements'].runes.toList()),
                  //overflow: TextOverflow.ellipsis, // Đảm bảo không bị tràn
                ),
                SizedBox(height: 20),
                Text(
                  "Quyền lợi: ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold), // Tô đậm label "Ngày đăng"
                ),
                Text(
                  utf8.decode(jobPost['benefits'].runes.toList()),
                  //overflow: TextOverflow.ellipsis, // Đảm bảo không bị tràn
                ),
                SizedBox(height: 8),
                Divider(
                  color: Colors.grey, // Đặt màu cho đường kẻ
                  thickness: 1, // Độ dày của đường kẻ
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      "Ngày đăng: ",
                      style: TextStyle(
                          fontWeight:
                              FontWeight.bold), // Tô đậm label "Ngày đăng"
                    ),
                    Expanded(
                      child: Text(
                        utf8.decode(jobPost['createdDate'].runes.toList()),
                        overflow:
                            TextOverflow.ellipsis, // Đảm bảo không bị tràn
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      "Thời hạn ứng tuyển: ",
                      style: TextStyle(
                          fontWeight:
                              FontWeight.bold), // Tô đậm label "Ngày đăng"
                    ),
                    Expanded(
                      child: Text(
                        utf8.decode(jobPost['expiryDate'].runes.toList()),
                        overflow:
                            TextOverflow.ellipsis, // Đảm bảo không bị tràn
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
