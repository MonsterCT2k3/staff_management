import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:staff_management/repositories/api_impl.dart';
import 'package:staff_management/widgets/common_widgets/noti_bar.dart';
import 'package:staff_management/widgets/screens/home/home_screen.dart';

import '../../../repositories/api.dart';

class ChangePasswordScreen extends StatefulWidget {
  static const String route = "ChangePasswordScreen";

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  Api _api = ApiImpl();
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () async {
              FocusScope.of(context).unfocus();
              await Future.delayed(Duration(milliseconds: 200));
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),
        title: Text(
          "Change Password",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        //automaticallyImplyLeading: false,
        backgroundColor: Colors.red,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _currentPasswordController,
                  decoration: InputDecoration(labelText: 'Mật khẩu hiện tại'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mật khẩu hiện tại';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _newPasswordController,
                  decoration: InputDecoration(labelText: 'Mật khẩu mới'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'Mật khẩu mới phải ít nhất 6 ký tự';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(labelText: 'Xác nhận mật khẩu mới'),
                  obscureText: true,
                  validator: (value) {
                    if (value != _newPasswordController.text) {
                      return 'Mật khẩu xác nhận không khớp';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    final password = prefs.getString('password');
                    if (_formKey.currentState!.validate()) {
                      FocusScope.of(context).unfocus();
                      final currentPass = _currentPasswordController.text;
                      final newPass = _newPasswordController.text;
                      final confirmPass = _confirmPasswordController.text;

                      print(password);
                      if (currentPass == newPass) {
                        // print('Current password and new password is the same');
                        ScaffoldMessenger.of(context)
                            .showSnackBar(notiBar("Current password and new password is the same", true));
                      } else if (password != currentPass) {
                        ScaffoldMessenger.of(context).showSnackBar(notiBar("Wrong current password", true));
                      } else {
                        try {
                          {
                            //await Future.delayed(Duration(milliseconds: 200));
                            final checkChangePassword = await _api.changePassword(_newPasswordController.text);
                            if (checkChangePassword == true) {
                              ScaffoldMessenger.of(context).showSnackBar(notiBar("Update information success", false));
                              Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.route));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(notiBar("Update information failed", true));
                            }
                            // Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.route));
                            // Xử lý logic đổi mật khẩu tại đây
                          }
                        } catch (e) {
                          print(e);
                        }
                      }
                    }
                  },
                  child: Text('Đổi mật khẩu'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
