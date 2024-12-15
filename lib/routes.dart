import 'package:flutter/material.dart';
import 'package:staff_management/widgets/screens/change_password/change_password_screen.dart';
import 'package:staff_management/widgets/screens/edit_information/edit_information_screen.dart';
import 'package:staff_management/widgets/screens/home/home_screen.dart';
import 'package:staff_management/widgets/screens/information/information_screen.dart';
import 'package:staff_management/widgets/screens/leave_requirement/leave_requirement_screen.dart';
import 'package:staff_management/widgets/screens/login/login_screen.dart';
import 'package:staff_management/widgets/screens/notification/notification_screen.dart';
import 'package:staff_management/widgets/screens/setting/setting_screen.dart';
import 'package:staff_management/widgets/screens/statistical/statistical_screen.dart';
import 'package:staff_management/widgets/screens/status_requirement/status_requirement_screen.dart';

Route<dynamic>? mainRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.route:
      return MaterialPageRoute(builder: (context) => LoginScreen());
    case HomeScreen.route:
      return MaterialPageRoute(builder: (context) => HomeScreen(), settings: RouteSettings(name: HomeScreen.route));
    case SettingScreen.route:
      return MaterialPageRoute(
          builder: (context) => SettingScreen(), settings: RouteSettings(name: SettingScreen.route));
    case InformationScreen.route:
      var employeeInfo = (settings.arguments as Map<String, dynamic>)['employeeInfo'];
      return MaterialPageRoute(builder: (context) => InformationScreen(employeeInfo));
    case EditInformationScreen.route:
      var employeeInfo = (settings.arguments as Map<String, dynamic>)['employeeInfo'];
      return MaterialPageRoute(builder: (context) => EditInformationScreen(employeeInfo));
    case ChangePasswordScreen.route:
      return MaterialPageRoute(builder: (context) => ChangePasswordScreen());
    case LeaveRequirementScreen.route:
      return MaterialPageRoute(builder: (context) => LeaveRequirementScreen());
    case StatisticalScreen.route:
      return MaterialPageRoute(builder: (context) => StatisticalScreen());
    case NotificationScreen.route:
      return MaterialPageRoute(builder: (context) => NotificationScreen());
    case StatusRequirementScreen.route:
      return MaterialPageRoute(builder: (context) => StatusRequirementScreen());
  }
}
