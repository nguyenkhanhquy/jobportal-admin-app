import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://mobile.jacobin.live/api/v1';
  //Hàm đăng nhập
  static Future<Map<String, dynamic>> login(
      {required String email, required String password}) async {
    final url = Uri.parse('$baseUrl/auth/login');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    return jsonDecode(response.body);
  }

//Hàm đăng xuất
  static Future<Map<String, dynamic>> logout({required String? token}) async {
    final url = Uri.parse('$baseUrl/auth/logout');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"token": token}),
    );

    return jsonDecode(response.body);
  }

  // Hàm lấy thông tin người dùng
  static Future<Map<String, dynamic>> getUserInfo(
      {required String token}) async {
    final url = Uri.parse('$baseUrl/auth/me');
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token", // Đưa token vào header để xác thực
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Trả về thông tin người dùng
    } else {
      throw Exception('Failed to load user data');
    }
  }

// Hàm đổi mật khẩu
  static Future<Map<String, dynamic>> changePassword({
    required String token,
    required String currentPassword,
    required String newPassword,
  }) async {
    final url = Uri.parse('$baseUrl/auth/update-password');
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token", // Token xác thực
      },
      body: jsonEncode({
        "password": currentPassword,
        "newPassword": newPassword,
      }),
    );

    // Trả về kết quả từ API
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to change password: ${response.body}');
    }
  }

  // Hàm tônổng hợp thông tin
  static Future<Map<String, dynamic>> getOverview(
      {required String token}) async {
    final url = Uri.parse('$baseUrl/dashboard/overview');
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token", // Đưa token vào header để xác thực
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Trả về thông tin người dùng
    } else {
      throw Exception('Failed to load user data');
    }
  }

  // Hàm tônổng hợp thông tin
  static Future<Map<String, dynamic>> getJobSeekers(
      {required String token}) async {
    final url = Uri.parse('$baseUrl/job-seeker');
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token", // Đưa token vào header để xác thực
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Trả về thông tin người dùng
    } else {
      throw Exception('Failed to load job seekers data');
    }
  }
}
