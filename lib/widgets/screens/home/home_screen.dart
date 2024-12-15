import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:staff_management/repositories/api.dart';
import 'package:staff_management/repositories/api_impl.dart';
import 'package:staff_management/widgets/common_widgets/appbar_custom.dart';
import 'package:staff_management/widgets/screens/information/information_screen.dart';
import 'package:staff_management/widgets/screens/leave_requirement/leave_requirement_screen.dart';
import 'package:staff_management/widgets/screens/menu/menu_screen.dart';
import 'package:staff_management/widgets/screens/statistical/statistical_screen.dart';

class HomeScreen extends StatelessWidget {
  static const String route = "HomeScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(context, "Staff Management"),
      drawer: Drawer(
        child: MenuScreen(),
      ),
      body: Column(
        children: [
          InformationStaff(),
          Divider(
            color: Colors.grey,
            thickness: 1,
            height: 1,
            indent: 20,
            endIndent: 20,
          ),
          Expanded(
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 32,
                  ),
                  CustomInkwell(
                    onTap: () {
                      Navigator.of(context).pushNamed(StatisticalScreen.route);
                    },
                    image: "assets/images/chart.png",
                    title: "Thống kê",
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  CustomInkwell(
                    onTap: () {
                      Navigator.of(context).pushNamed(LeaveRequirementScreen.route);
                    },
                    image: "assets/images/form.png",
                    title: 'Nộp đơn xin nghỉ',
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CustomInkwell extends StatelessWidget {
  final VoidCallback? onTap;
  final String image;
  final String title;

  const CustomInkwell({
    required this.onTap,
    required this.image,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Ink(
        padding: EdgeInsets.all(12),
        //height: 150,
        width: 200,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.red.shade400, width: 1),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 3,
                blurRadius: 5,
                offset: Offset(2, 2),
              )
            ]),
        child: Container(
          child: Column(
            children: [
              Container(
                height: 100,
                child: Image.asset(image),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InformationStaff extends StatefulWidget {
  @override
  State<InformationStaff> createState() => _InformationStaffState();
}

class _InformationStaffState extends State<InformationStaff> {
  Map<String, dynamic>? _employeeInfo;
  final Api _api = ApiImpl();

  Future<void> _loadEmployeeInfo() async {
    try {
      // Lấy token và id từ SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final id = prefs.getInt('id_employee');

      if (id == null) {
        throw Exception('Employee ID not found');
      }

      // Gọi API để lấy thông tin nhân viên
      final info = await _api.getEmployeeInfo(id);

      if (info != null) {
        setState(() {
          _employeeInfo = info;
        });
      } else {
        throw Exception('Failed to load employee info');
      }
    } catch (e) {
      print('Error loading employee info: $e');
      // Hiển thị thông báo lỗi (nếu cần)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load employee info')),
      );
    }
  }

  @override
  void initState() {
    _loadEmployeeInfo();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(InformationScreen.route, arguments: {'employeeInfo': _employeeInfo});
      },
      child: Container(
        height: 80,
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage("assets/images/avatar.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            _employeeInfo == null
                ? CircularProgressIndicator()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "${_employeeInfo?['name']}  | ",
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Text("ID: ${_employeeInfo?['id']}")
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [Text("role: ${_employeeInfo?['role']}")],
                      )
                    ],
                  )
          ],
        ),
      ),
    );
  }
}
