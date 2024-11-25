import 'package:flutter/material.dart';
import 'dart:convert';
import '../services/api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RecruiterScreen extends StatefulWidget {
  final List<dynamic> recruiterData;

  RecruiterScreen({required this.recruiterData});

  @override
  _RecruiterScreenState createState() => _RecruiterScreenState();
}

class _RecruiterScreenState extends State<RecruiterScreen> {
  late List<dynamic> recruiterData;

  @override
  void initState() {
    super.initState();
    recruiterData = widget.recruiterData;
  }

  Future<void> toggleLockStatus({
    required BuildContext context,
    required Map<String, dynamic> recruiter,
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
      setDialogState(() => recruiter['isLoading'] = true);
      final response =
          await ApiService.lockChange(id: recruiter['id'], token: token);

      if (response['success'] == true) {
        setState(() {
          recruiter['locked'] = !recruiter['locked'];
        });
        _showSnackBar(
          context,
          recruiter['locked'] ? 'Khóa thành công!' : 'Mở khóa thành công!',
          isError: false,
        );
        Navigator.of(context).pop(); // Đóng dialog nếu cần
      } else {
        throw Exception(response['message'] ?? 'Đổi trạng thái thất bại!');
      }
    } catch (error) {
      _showSnackBar(context, 'Lỗi: ${error.toString()}', isError: true);
    } finally {
      setDialogState(() => recruiter['isLoading'] = false);
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
      BuildContext context, Map<String, dynamic> recruiter) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateDialog) {
            return AlertDialog(
              title: Text("Thông tin chi tiết"),
              content: SingleChildScrollView(
                child: _buildDetailsContent(recruiter),
              ),
              actions: _buildDialogActions(context, recruiter, setStateDialog),
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

  Widget _buildDetailsContent(Map<String, dynamic> recruiter) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              recruiter['company']['logo'] ?? '',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 8),
        _buildSectionTitle('THÔNG TIN CÔNG TY'),
        SizedBox(height: 8),
        _buildRichTextWithSpacing(
          'Công ty',
          recruiter['company']['name'] != null
              ? utf8.decode(
                  recruiter['company']['name'].toString().runes.toList())
              : 'Chưa cập nhật',
        ),
        _buildRichTextWithSpacing(
          'Website',
          recruiter['company']['website'] != null
              ? utf8.decode(
                  recruiter['company']['website'].toString().runes.toList())
              : 'Chưa cập nhật',
        ),
        _buildRichTextWithSpacing(
          'Địa chỉ',
          recruiter['company']['address'] != null
              ? utf8.decode(
                  recruiter['company']['address'].toString().runes.toList())
              : 'Chưa cập nhật',
        ),
        _buildRichTextWithSpacing('Email', recruiter['email']),
        _buildSectionTitle('NGƯỜI ĐẠI DIỆN'),
        SizedBox(height: 8),
        _buildRichTextWithSpacing(
          'Họ và tên',
          utf8.decode(recruiter['name'].toString().runes.toList()),
        ),
        _buildRichTextWithSpacing(
          'Chức vụ',
          utf8.decode(recruiter['position'].toString().runes.toList()),
        ),
        _buildRichTextWithSpacing('Email', recruiter['recruiterEmail']),
        _buildRichTextWithSpacing('Số điện thoại', recruiter['phone']),
        _buildRichTextWithSpacing(
          'Trạng thái hoạt động',
          recruiter['locked'] != null
              ? (recruiter['locked'] ? 'Đã bị khóa' : 'Bình thường')
              : 'Chưa cập nhật',
          statusColor: recruiter['locked'] != null
              ? (recruiter['locked'] ? Colors.red : Colors.green)
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
    Map<String, dynamic> recruiter,
    StateSetter setDialogState,
  ) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: recruiter['isLoading'] == true
                ? null
                : () => toggleLockStatus(
                      context: context,
                      recruiter: recruiter,
                      setDialogState: setDialogState,
                    ),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  recruiter['locked'] == true ? Colors.green : Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
            ),
            child: recruiter['isLoading'] == true
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2.0),
                  )
                : Text(
                    recruiter['locked'] == true ? "Mở Khóa" : "Khóa",
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
      appBar: AppBar(title: Text('Quản lý nhà tuyển dụng')),
      body: ListView.builder(
        itemCount: recruiterData.length,
        itemBuilder: (context, index) {
          final user = recruiterData[index];
          return _buildRecruiterCard(context, user);
        },
      ),
    );
  }

  Widget _buildRecruiterCard(BuildContext context, Map<String, dynamic> user) {
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
              utf8.decode(user['company']['name'].toString().runes.toList()),
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
