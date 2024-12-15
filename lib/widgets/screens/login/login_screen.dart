import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:staff_management/common/enum/load_status.dart';
import 'package:staff_management/models/login.dart';
import 'package:staff_management/repositories/api.dart';
import 'package:staff_management/widgets/common_widgets/noti_bar.dart';
import 'package:staff_management/widgets/screens/home/home_screen.dart';
import 'package:staff_management/widgets/screens/login/login_cubit.dart';

class LoginScreen extends StatelessWidget {
  static const String route = "LoginScreen";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(context.read<Api>()),
      child: Page(),
    );
  }
}

class Page extends StatelessWidget {
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.loadStatus == LoadStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(notiBar("Wrong infomation", true));
          } else if (state.loadStatus == LoadStatus.done) {
            Navigator.of(context).pushNamed(HomeScreen.route);
          }
        },
        builder: (context, state) {
          return state.loadStatus == LoadStatus.loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(), // Đóng bàn phím khi chạm ra ngoài
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.orange.shade900,
                          Colors.orange.shade800,
                          Colors.orange.shade400,
                        ],
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 80),
                          Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Login",
                                  style: TextStyle(color: Colors.white, fontSize: 40),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Welcome Back",
                                  style: TextStyle(color: Colors.white, fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height - 250, // Điều chỉnh chiều cao
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(60),
                                topRight: Radius.circular(60),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    SizedBox(height: 60),
                                    Container(
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color.fromRGBO(255, 95, 27, .3),
                                            blurRadius: 20,
                                            offset: Offset(0, 10),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(color: Colors.grey.shade200),
                                              ),
                                            ),
                                            child: TextField(
                                              controller: usernameController,
                                              decoration: InputDecoration(
                                                labelText: "Username",
                                                labelStyle: TextStyle(color: Colors.grey, fontSize: 20),
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(color: Colors.grey.shade200),
                                              ),
                                            ),
                                            child: TextField(
                                              controller: passwordController,
                                              obscureText: true, // Ẩn mật khẩu
                                              decoration: InputDecoration(
                                                labelText: "Password",
                                                labelStyle: TextStyle(color: Colors.grey, fontSize: 20),
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 40),
                                    Text(
                                      "Forgot Password?",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    SizedBox(height: 40),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange.shade900,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(50),
                                        ),
                                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                                      ),
                                      onPressed: () {
                                        if (usernameController.text == '' && passwordController.text == '') {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(notiBar("Please fill information", true));
                                        } else if (usernameController.text == '') {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(notiBar("Username is required", true));
                                        } else if (passwordController.text == '') {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(notiBar("Password is required", true));
                                        } else {
                                          context.read<LoginCubit>().checkLogin(Login(
                                              username: usernameController.text, password: passwordController.text));
                                        }
                                      },
                                      child: Text(
                                        "Login",
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }
}
