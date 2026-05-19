import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  static const String BASE_URL = 'http://127.0.0.1:8080/api';

  late Dio _dio;

  ApiClient._internal() {
    _initializeDio();
  }

  static final ApiClient _instance = ApiClient._internal();

  factory ApiClient() => _instance;

  void _initializeDio() {
    _dio = Dio(BaseOptions(
      baseUrl: BASE_URL,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ));

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('auth_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (error, handler) {
          _handleError(error);
          return handler.next(error);
        },
      ),
    );
  }

  Future<Response> get(String endpoint) async {
    try {
      return await _dio.get(endpoint);
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  Future<Response> post(String endpoint,
      {required Map<String, dynamic> data}) async {
    try {
      return await _dio.post(endpoint, data: data);
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  Future<Response> put(String endpoint,
      {required Map<String, dynamic> data}) async {
    try {
      return await _dio.put(endpoint, data: data);
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  Future<Response> delete(String endpoint) async {
    try {
      return await _dio.delete(endpoint);
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  void _handleError(DioException error) {
    if (error.response == null) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          throw Exception('Connection timeout — is Spring Boot running?');
        case DioExceptionType.receiveTimeout:
          throw Exception('Server took too long to respond');
        case DioExceptionType.connectionError:
          throw Exception(
              'Cannot connect to server — make sure Spring Boot is running on port 8080');
        default:
          throw Exception(
              'Network error: ${error.message ?? 'Unknown error occurred'}');
      }
    }

    switch (error.response?.statusCode) {
      case 400:
        throw Exception('Bad request — ${error.response?.data?['message'] ?? 'invalid input'}');
      case 401:
        throw Exception('Unauthorized — please log in again');
      case 403:
        throw Exception('Forbidden — insufficient permissions');
      case 404:
        throw Exception('Resource not found');
      case 500:
        throw Exception('Server error — try again later');
      default:
        throw Exception(
            error.response?.data?['message'] ?? error.message ?? 'Unknown error occurred');
    }
  }
}