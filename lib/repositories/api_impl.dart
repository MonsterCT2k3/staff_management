import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:staff_management/models/login.dart';
import 'package:staff_management/repositories/api.dart';
import 'package:staff_management/repositories/dio_client.dart';
// import 'package:staff_management/repositories/log.dart';

class ApiImpl implements Api {
  final DioClient _dioClient = DioClient();

  @override
  // Lưu token vào SharedPreferences
  Future<void> saveToken(String token, int id, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setInt('id_employee', id);
    await prefs.setString('password', password);
  }

  @override
  // Xóa token khỏi SharedPreferences
  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('id_employee');
    await prefs.remove('password');
  }

  @override
  // Đăng nhập
  Future<bool> checkLogin(Login login) async {
    try {
      final response = await _dioClient.dio.post(
        '/auth/login',
        data: {
          'username': login.username,
          'password': login.password,
        },
      );

      if (response.statusCode == 200) {
        final token = response.data['access_token'];
        final id = response.data['id'];
        print(token);
        print("id: $id");
        try {
          await saveToken(token, id, login.password);
        } catch (e) {
          print(e);
        }

        print('done');
        return true;
      }
      return false;
    } catch (e) {
      if (e is DioException) {
        print('Login Error: ${e.response?.data}');
      }
      return false;
    }
  }

  @override
  // Đăng xuất
  Future<bool> logout(String token) async {
    print(token);
    try {
      print(token);
      final response = await _dioClient.dio.post(
        '/auth/logout',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        await removeToken();
        return true;
      }
      return false;
    } catch (e) {
      if (e is DioException) {
        print('Logout Error: ${e.response?.data}');
      }
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>?> getEmployeeInfo(int id) async {
    try {
      final response = await _dioClient.dio.get("/employee/$id");
      if (response.statusCode == 200) {
        return response.data['employee'];
      }
    } catch (e) {
      print(e);
      return null;
    }
    return null;
  }

  @override
  Future<bool?> updateEmployeeInfo(String email, String address, String phone, int id) async {
    try {
      final response =
          await _dioClient.dio.post('/employee/update/$id', data: {'phone': phone, 'email': email, 'address': address});
      if (response.statusCode == 200)
        return true;
      else
        return false;
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<bool?> changePassword(String password) async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('id_employee');
    try {
      final response = await _dioClient.dio.post('/employee/update/$id', data: {'password': password});
      if (response.statusCode == 200)
        return true;
      else
        return false;
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<bool?> leaveRequirement(String startDate, String endDate, String requestType, String reason) async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('id_employee');
    try {
      final response = await _dioClient.dio.post('/leave_request/create', data: {
        'id_employee': id,
        'start_date': startDate,
        'end_date': endDate,
        'request_type': requestType,
        'reason': reason
      });
      if (response.statusCode == 201)
        return true;
      else
        return false;
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<List<dynamic>?> getEmployeeLeaveRequests() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('id_employee');
    try {
      final response = await _dioClient.dio.get(
        '/leave_request/employee_requests',
        queryParameters: {'id_employee': id},
      );

      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      print('Error fetching leave requests: $e');
    }
    return null;
  }

  @override
  Future<List<Map<String, dynamic>>> getEmployeeAttendance() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('id_employee');
    try {
      final response = await _dioClient.dio.get(
        '/attendance/employee/$id',
      );
      if (response.statusCode == 200) {
        List<dynamic> attendanceData = response.data['attendance_data'];
        return List<Map<String, dynamic>>.from(attendanceData);
      }
    } catch (e) {
      print('Error fetching leave requests: $e');
    }
    return [];
  }
}
