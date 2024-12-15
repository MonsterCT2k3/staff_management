import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:staff_management/common/enum/drawer_item.dart';
import 'package:staff_management/main_cubit.dart';
import 'package:staff_management/repositories/api.dart';
import 'package:staff_management/repositories/api_impl.dart';
import 'package:staff_management/widgets/screens/home/home_screen.dart';
import 'package:staff_management/widgets/screens/login/login_screen.dart';
import 'package:staff_management/widgets/screens/setting/setting_screen.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Page();
  }
}

class Page extends StatelessWidget {
  final Api _api = ApiImpl();

  Future<bool?> _showLogoutConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout'),
          content: Text('Are you sure you want to logout?'),
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
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCubit, MainState>(
      builder: (context, state) {
        return SafeArea(
          child: Container(
            child: Column(
              children: [
                SizedBox(
                  height: 32,
                ),
                ListTile(
                  title: Text("Home"),
                  trailing: state.selected != DrawerItem.home ? Icon(Icons.navigate_next) : null,
                  onTap: () {
                    context.read<MainCubit>().setSelected(DrawerItem.home);
                    Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.route));
                  },
                ),
                ListTile(
                  title: Text("Settings"),
                  trailing: state.selected != DrawerItem.setting ? Icon(Icons.navigate_next) : null,
                  onTap: () {
                    context.read<MainCubit>().setSelected(DrawerItem.setting);
                    Navigator.of(context).pushNamed(SettingScreen.route);
                  },
                ),
                ListTile(
                  title: Text("Logout"),
                  trailing: state.selected != DrawerItem.logout ? Icon(Icons.navigate_next) : null,
                  onTap: () async {
                    context.read<MainCubit>().setSelected(DrawerItem.logout);
                    final shouldLogout = await _showLogoutConfirmationDialog(context);
                    if (shouldLogout == true) {
                      final prefs = await SharedPreferences.getInstance();
                      final token = prefs.getString('auth_token');
                      print(token);
                      final success = await _api.logout(token!);
                      if (success) {
                        Navigator.of(context).popUntil(ModalRoute.withName(LoginScreen.route));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Logout failed')),
                        );
                      }
                    }
                    Navigator.of(context).pushNamed(LoginScreen.route);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
