import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioClient {
  late Dio _dio;

  DioClient() {
    _dio = Dio(BaseOptions(
      baseUrl: 'http://127.0.0.1:5000', // Thay bằng URL API của bạn
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
