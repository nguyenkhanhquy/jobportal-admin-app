import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import '../services/api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class JobPostScreen extends StatefulWidget {
  final List<dynamic> jobpostData;

  JobPostScreen({required this.jobpostData});

  @override
  _JobPostScreenState createState() => _JobPostScreenState();
}

class _JobPostScreenState extends State<JobPostScreen> {
  late List<dynamic> jobpostData;

  @override
  void initState() {
    super.initState();
    jobpostData = widget.jobpostData;
  }

  Future<void> toggleHiddenStatus({
    required BuildContext context,
    required Map<String, dynamic> jobpost,
    required Function setDialogState,
  }) async {
    final storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'token');

    if (token == null) {
      _showSnackBar(context, 'Không tìm thấy token! Vui lòng đăng nhập lại.',
          isError: true);
      return;
    }

    try {
      setDialogState(() => jobpost['isLoading'] = true);
      final response =
          await ApiService.hiddenChange(id: jobpost['id'], token: token);

      if (response['success'] == true) {
        setState(() {
          jobpost['hidden'] = !jobpost['hidden'];
        });
        _showSnackBar(
          context,
          jobpost['hidden'] ? 'Khóa thành công!' : 'Mở khóa thành công!',
          isError: false,
        );
        Navigator.of(context).pop(); // Đóng dialog nếu cần
      } else {
        throw Exception(response['message'] ?? 'Đổi trạng thái thất bại!');
      }
    } catch (error) {
      _showSnackBar(context, 'Lỗi: ${error.toString()}', isError: true);
    } finally {
      setDialogState(() => jobpost['isLoading'] = false);
    }
  }

  void _showSnackBar(BuildContext context, String message,
      {bool isError = false}) {
    //String messagee = utf8.decode(message.runes.toList());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  void _showDetailsDialog(BuildContext context, Map<String, dynamic> jobpost) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateDialog) {
            return AlertDialog(
              title: Text("Thông tin chi tiết"),
              content: SingleChildScrollView(
                child: _buildDetailsContent(jobpost),
              ),
              actions: _buildDialogActions(context, jobpost, setStateDialog),
            );
          },
        );
      },
    );
  }

  Widget _buildRichText(String label, String value, {Color? statusColor}) {
    // Cung cấp giá trị mặc định nếu statusColor là null
    final Color effectiveColor =
        statusColor ?? Colors.black; // Mặc định là màu đen nếu không có giá trị

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: label + ": ",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          TextSpan(
            text: value,
            style: TextStyle(color: effectiveColor),
          ),
        ],
      ),
    );
  }

  Widget _buildRichTextforCard(String label, String value,
      {Color? statusColor}) {
    // Cung cấp giá trị mặc định nếu statusColor là null
    final Color effectiveColor =
        statusColor ?? Colors.black; // Mặc định là màu đen nếu không có giá trị

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: label + ": ",
            style: TextStyle(color: Colors.grey[600]),
          ),
          TextSpan(
            text: value,
            style:
                TextStyle(fontWeight: FontWeight.bold, color: effectiveColor),
          ),
        ],
      ),
    );
  }

  Widget _buildRichTextWithSpacing(String label, String value,
      {Color? statusColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRichText(label, value, statusColor: statusColor),
        SizedBox(height: 8), // Khoảng cách giữa các mục
      ],
    );
  }

  Widget _buildDetailsContent(Map<String, dynamic> jobpost) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8),
        _buildRichTextWithSpacing(
          'Tiêu đề',
          utf8.decode(jobpost['title'].toString().runes.toList()),
        ),
        _buildRichTextWithSpacing(
          'Tên công ty',
          utf8.decode(jobpost['company']['name'].toString().runes.toList()),
        ),
        _buildRichTextWithSpacing('Vị trí tuyển dụng',
            utf8.decode(jobpost['jobPosition'].toString().runes.toList())),
        _buildRichTextWithSpacing(
          'Mức lương',
          utf8.decode(jobpost['salary'].toString().runes.toList()),
        ),
        _buildRichTextWithSpacing(
          'Số lượng',
          jobpost['quantity'].toString(),
        ),
        _buildRichTextWithSpacing(
          'Loại hợp đồng',
          utf8.decode(jobpost['type'].toString().runes.toList()),
        ),
        _buildRichTextWithSpacing('Địa điểm làm việc',
            utf8.decode(jobpost['address'].toString().runes.toList())),
        Divider(
          color: Colors.grey, // Đặt màu cho đường kẻ
          thickness: 1, // Độ dày của đường kẻ
        ),
        _buildRichTextWithSpacing('Mô tả công việc',
            utf8.decode(jobpost['description'].toString().runes.toList())),
        Divider(
          color: Colors.grey, // Đặt màu cho đường kẻ
          thickness: 1, // Độ dày của đường kẻ
        ),
        _buildRichTextWithSpacing('Yêu cầu',
            utf8.decode(jobpost['requirements'].toString().runes.toList())),
        Divider(
          color: Colors.grey, // Đặt màu cho đường kẻ
          thickness: 1, // Độ dày của đường kẻ
        ),
        _buildRichTextWithSpacing('Quyền lợi',
            utf8.decode(jobpost['benefits'].toString().runes.toList())),
        Divider(
          color: Colors.grey, // Đặt màu cho đường kẻ
          thickness: 1, // Độ dày của đường kẻ
        ),
        _buildRichTextWithSpacing('Ngày đăng',
            utf8.decode(jobpost['createdDate'].toString().runes.toList())),
        _buildRichTextWithSpacing('Thời hạn ứng tuyển',
            utf8.decode(jobpost['expiryDate'].toString().runes.toList())),
        // _buildRichTextWithSpacing(
        //   'Trạng thái tài khoản: ',
        //   jobpost['locked'] != null
        //       ? (jobpost['locked'] ? 'Đã bị khóa' : 'Bình thường')
        //       : 'Chưa cập nhật',
        //   statusColor: jobpost['locked'] != null
        //       ? (jobpost['locked'] ? Colors.red : Colors.green)
        //       : Colors.grey,
        // ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Center(
      child: DecoratedBox(
        decoration: BoxDecoration(
            color: Colors.green[100], borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDialogActions(
    BuildContext context,
    Map<String, dynamic> jobpost,
    StateSetter setDialogState,
  ) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: jobpost['isLoading'] == true
                ? null
                : () => toggleHiddenStatus(
                      context: context,
                      jobpost: jobpost,
                      setDialogState: setDialogState,
                    ),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  jobpost['hidden'] == true ? Colors.green : Colors.grey,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
            ),
            child: jobpost['isLoading'] == true
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2.0),
                  )
                : Text(
                    jobpost['hidden'] == true ? "Hiện" : "Ẩn",
                    style: TextStyle(color: Colors.white),
                  ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              backgroundColor: Colors.grey[400], // Màu nền
              foregroundColor: Colors.black, // Màu chữ
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Bo góc nếu cần
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: 16, vertical: 10), // Padding nếu cần
            ),
            child: Text("Đóng"),
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quản lý bài đăng')),
      body: ListView.builder(
        itemCount: jobpostData.length,
        itemBuilder: (context, index) {
          final job = jobpostData[index];
          return _buildjobpostCard(context, job);
        },
      ),
    );
  }

  Widget _buildjobpostCard(BuildContext context, Map<String, dynamic> job) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
            color: job['hidden'] ? Colors.grey : Colors.green, width: 1),
      ),
      elevation: 2,
      color: job['hidden'] ? Colors.grey[500] : Colors.green[100],
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              utf8.decode(job['title'].toString().runes.toList()),
              style: TextStyle(fontSize: 18),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            SizedBox(height: 4),
            Text(
              utf8.decode(job['company']['name'].toString().runes.toList()),
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            SizedBox(height: 4),
            _buildRichTextforCard(
              'Trạng thái',
              job['hidden'] ? 'Đã ẩn' : 'Đang hiển thị',
              statusColor: job['hidden'] ? Colors.black : Color(0xFF006E33),
            ),
          ],
        ),
        onTap: () => _showDetailsDialog(context, job),
        trailing: Icon(
          job['hidden'] ? Icons.visibility_off : Icons.visibility,
          color: job['hidden'] ? Colors.black : Colors.green,
          size: 30,
        ),
      ),
    );
  }
}
