import 'package:staff_management/models/login.dart';

abstract class Api {
  Future<bool> checkLogin(Login login);

  Future<void> saveToken(String token, int id, String password);

  Future<void> removeToken();

  Future<bool> logout(String token);

  Future<Map<String, dynamic>?> getEmployeeInfo(int id);

  Future<bool?> updateEmployeeInfo(String email, String address, String phone, int id);

  Future<bool?> changePassword(String password);

  Future<bool?> leaveRequirement(String startDate, String endDate, String requestType, String reason);

  Future<List<dynamic>?> getEmployeeLeaveRequests();

  Future<List<Map<String, dynamic>>?> getEmployeeAttendance();
}
