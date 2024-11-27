import 'package:flutter/material.dart';
import 'dart:convert';
import '../services/api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class JobSeekerScreen extends StatefulWidget {
  final List<dynamic> jobseekerData;

  JobSeekerScreen({required this.jobseekerData});

  @override
  _JobSeekerScreenState createState() => _JobSeekerScreenState();
}

class _JobSeekerScreenState extends State<JobSeekerScreen> {
  late List<dynamic> jobseekerData;

  @override
  void initState() {
    super.initState();
    jobseekerData = widget.jobseekerData;
  }

  Future<void> toggleLockStatus({
    required BuildContext context,
    required Map<String, dynamic> jobseeker,
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
      setDialogState(() => jobseeker['isLoading'] = true);
      final response =
          await ApiService.lockChange(id: jobseeker['id'], token: token);

      if (response['success'] == true) {
        setState(() {
          jobseeker['locked'] = !jobseeker['locked'];
        });
        _showSnackBar(
          context,
          jobseeker['locked'] ? 'Khóa thành công!' : 'Mở khóa thành công!',
          isError: false,
        );
        Navigator.of(context).pop(); // Đóng dialog nếu cần
      } else {
        throw Exception(response['message'] ?? 'Đổi trạng thái thất bại!');
      }
    } catch (error) {
      _showSnackBar(context, 'Lỗi: ${error.toString()}', isError: true);
    } finally {
      setDialogState(() => jobseeker['isLoading'] = false);
    }
  }

  void _showSnackBar(BuildContext context, String message,
      {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  void _showDetailsDialog(
      BuildContext context, Map<String, dynamic> jobseeker) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateDialog) {
            return AlertDialog(
              title: Text("Thông tin chi tiết"),
              content: SingleChildScrollView(
                child: _buildDetailsContent(jobseeker),
              ),
              actions: _buildDialogActions(context, jobseeker, setStateDialog),
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

  Widget _buildRichTextWithSpacing(String label, String? value,
      {Color? statusColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRichText(
            label, (value == null || value == 'null') ? "Chưa cập nhật" : value,
            statusColor: statusColor),
        SizedBox(height: 8), // Khoảng cách giữa các mục
      ],
    );
  }

  Widget _buildDetailsContent(Map<String, dynamic> jobseeker) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8),
        _buildRichTextWithSpacing(
          'ID',
          jobseeker['id'],
        ),
        _buildRichTextWithSpacing(
          'Email',
          jobseeker['email'],
        ),
        _buildRichTextWithSpacing('Họ và tên',
            utf8.decode(jobseeker['fullName'].toString().runes.toList())),
        _buildRichTextWithSpacing(
            'Ngày đăng ký', jobseeker['registrationDate']),
        _buildRichTextWithSpacing(
          'Ngày sinh',
          jobseeker['registrationDate'],
        ),
        _buildRichTextWithSpacing(
          'Số điện thoại',
          jobseeker['phone'],
        ),
        _buildRichTextWithSpacing('Địa chỉ',
            utf8.decode(jobseeker['address'].toString().runes.toList())),
        _buildRichTextWithSpacing('Kinh nghiệm',
            utf8.decode(jobseeker['workExperience'].toString().runes.toList())),
        _buildRichTextWithSpacing(
          'Trạng thái tài khoản',
          jobseeker['locked'] != null
              ? (jobseeker['locked'] ? 'Đã bị khóa' : 'Bình thường')
              : 'Chưa cập nhật',
          statusColor: jobseeker['locked'] != null
              ? (jobseeker['locked'] ? Colors.red : Colors.green)
              : Colors.grey,
        ),
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
    Map<String, dynamic> jobseeker,
    StateSetter setDialogState,
  ) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: jobseeker['isLoading'] == true
                ? null
                : () => toggleLockStatus(
                      context: context,
                      jobseeker: jobseeker,
                      setDialogState: setDialogState,
                    ),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  jobseeker['locked'] == true ? Colors.green : Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
            ),
            child: jobseeker['isLoading'] == true
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2.0),
                  )
                : Text(
                    jobseeker['locked'] == true ? "Mở Khóa" : "Khóa",
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
      appBar: AppBar(title: Text('Quản lý ứng viên')),
      body: ListView.builder(
        itemCount: jobseekerData.length,
        itemBuilder: (context, index) {
          final user = jobseekerData[index];
          return _buildjobseekerCard(context, user);
        },
      ),
    );
  }

  Widget _buildjobseekerCard(BuildContext context, Map<String, dynamic> user) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
            color: user['locked'] ? Colors.red : Colors.green, width: 1),
      ),
      elevation: 2,
      color: user['locked'] ? Colors.red[100] : Colors.green[100],
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              utf8.decode(user['email'].toString().runes.toList()),
              style: TextStyle(fontSize: 18),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            SizedBox(height: 4),
            Text(
              utf8.decode(user['fullName'].toString().runes.toList()),
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            SizedBox(height: 4),
            _buildRichTextforCard(
              'Trạng thái',
              user['locked'] ? 'Đã bị khóa' : 'Bình thường',
              statusColor:
                  user['locked'] ? Color(0xFFAB2328) : Color(0xFF006E33),
            ),
          ],
        ),
        onTap: () => _showDetailsDialog(context, user),
        trailing: Icon(
          user['locked'] ? Icons.lock : Icons.lock_open,
          color: user['locked'] ? Colors.red : Colors.green,
          size: 30,
        ),
      ),
    );
  }
}
