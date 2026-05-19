import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_client.dart';
import 'models.dart';

class AuthRepository {
  final ApiClient _apiClient = ApiClient();

  Future<ApiResponse<Map<String, dynamic>>> login(
      String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8080/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );
      print('Status: ${response.statusCode}');
      print('Body: ${response.body}');
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final apiResponse = ApiResponse.fromJson(json, (j) => j as Map<String, dynamic>);

      if (apiResponse.success && apiResponse.data != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', apiResponse.data!['token']);
      }

      return apiResponse;
    } catch (e) {
      print('HTTP ERROR: $e');
      throw Exception('Login failed: $e');
    }
  }

  Future<ApiResponse<void>> register(
      String username, String email, String password, String role) async {
    try {
      print('SENDING: username=$username email=$email password=$password role=$role');
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8080/api/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
          'role': role,
        }),
      );
      print('Register Status: ${response.statusCode}');
      print('Register Body: ${response.body}');
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return ApiResponse.fromJson(json, (_) {});
    } catch (e) {
      print('HTTP ERROR: $e');
      throw Exception('Register failed: $e');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token') != null;
  }
}