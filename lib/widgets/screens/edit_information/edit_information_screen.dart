import 'package:flutter/material.dart';
import 'package:staff_management/repositories/api.dart';
import 'package:staff_management/repositories/api_impl.dart';
import 'package:staff_management/widgets/common_widgets/noti_bar.dart';

import '../home/home_screen.dart';

class EditInformationScreen extends StatelessWidget {
  Map<String, dynamic> employeeInfo;

  EditInformationScreen(this.employeeInfo);

  static const String route = "EditInformationScreen";

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
          "Edit Information",
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
  Api _api = ApiImpl();
  Map<String, dynamic> employeeInfo;

  Future<bool?> _showUpdateConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Update Information'),
          content: Text('Are you sure you want to update information?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Hủy logout
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Xác nhận logout
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Page(this.employeeInfo);

  @override
  Widget build(BuildContext context) {
    var phoneController = TextEditingController();
    phoneController.text = employeeInfo['phone'];
    var emailController = TextEditingController();
    emailController.text = employeeInfo['email'];
    var addressController = TextEditingController();
    addressController.text = employeeInfo['address'];
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(), // Đóng bàn phím khi chạm ra ngoài
      child: Column(
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
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 32,
                    ),
                    Expanded(
                      flex: 1,
                      child: Text("Số điện thoại:"),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.only(right: 32),
                        child: TextField(
                          controller: phoneController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 32,
                    ),
                    Expanded(
                      flex: 1,
                      child: Text("Email:"),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.only(right: 32),
                        child: TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 32,
                    ),
                    Expanded(flex: 1, child: Text("Địa chỉ:")),
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.only(right: 32),
                        child: TextField(
                          controller: addressController,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 32,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade50),
                  onPressed: () async {
                    final shouldUpdate = await _showUpdateConfirmationDialog(context);
                    if (shouldUpdate == true) {
                      try {
                        employeeInfo['phone'] = phoneController.text;
                        employeeInfo['email'] = emailController.text;
                        employeeInfo['address'] = addressController.text;
                        print(employeeInfo);
                        final checkUpdate = await _api.updateEmployeeInfo(
                            employeeInfo['email'], employeeInfo['address'], employeeInfo['phone'], employeeInfo['id']);
                        if (checkUpdate == true) {
                          ScaffoldMessenger.of(context).showSnackBar(notiBar("Update information success", false));
                          Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.route));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(notiBar("Update information failed", true));
                        }
                      } catch (e) {
                        print(e);
                      }
                    }
                    //Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.route));
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
