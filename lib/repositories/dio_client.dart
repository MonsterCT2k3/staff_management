import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioClient {
  late Dio _dio;

  DioClient() {
    _dio = Dio(BaseOptions(
      baseUrl: 'https://aeeb-2405-4802-21a-90f0-b51e-f2cc-4f6d-37bb.ngrok-free.app', // Thay bằng URL API của bạn
      connectTimeout: Duration(milliseconds: 5000), // 5 giây
      receiveTimeout: Duration(milliseconds: 3000),
    ));
  }

  Dio get dio => _dio;

  // Hàm giả định để lấy token từ bộ nhớ cục bộ
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
}
