import 'package:flutter/material.dart';
import 'package:staff_management/widgets/common_widgets/text_custom.dart';
import 'package:staff_management/widgets/screens/change_password/change_password_screen.dart';
import 'package:staff_management/widgets/screens/edit_information/edit_information_screen.dart';

class InformationScreen extends StatelessWidget {
  static const String route = "InformationScreen";
  Map<String, dynamic> employeeInfo;

  InformationScreen(this.employeeInfo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),
        title: Text(
          "Staff Information",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        //automaticallyImplyLeading: false,
        backgroundColor: Colors.red,
      ),
      body: Page(employeeInfo),
    );
  }
}

class Page extends StatelessWidget {
  Map<String, dynamic> employeeInfo;

  Page(this.employeeInfo);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 120,
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage("assets/images/avatar.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        employeeInfo['name'],
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "ID: ${employeeInfo['id']}",
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 16,
                  ),
                  TextCustom("Chức vụ: "),
                  TextCustom(employeeInfo['role']),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 16,
                  ),
                  TextCustom("Phòng ban: "),
                  TextCustom(employeeInfo['department']),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 16,
                  ),
                  TextCustom("Số điện thoai: "),
                  TextCustom(employeeInfo['phone']),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 16,
                  ),
                  TextCustom("Email: "),
                  TextCustom(employeeInfo['email']),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 16,
                  ),
                  TextCustom("Giới tính: "),
                  TextCustom(employeeInfo['gender']),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 16,
                  ),
                  TextCustom("Địa chỉ: "),
                  TextCustom(employeeInfo['address']),
                ],
              ),
              SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade50,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(EditInformationScreen.route, arguments: {'employeeInfo': employeeInfo});
            },
            child: Text(
              "Cập nhật thông tin",
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
        SizedBox(
          height: 24,
        ),
        Center(
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade50,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(ChangePasswordScreen.route);
              },
              child: Text(
                "Đổi mật khẩu",
                style: TextStyle(fontSize: 20, color: Colors.red),
              )),
        )
      ],
    );
  }
}
