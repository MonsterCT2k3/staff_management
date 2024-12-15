import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:staff_management/main_cubit.dart';
import 'package:staff_management/widgets/common_widgets/appbar_custom.dart';
import 'package:staff_management/widgets/screens/menu/menu_screen.dart';

class SettingScreen extends StatefulWidget {
  static const String route = "SettingScreen";

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCubit, MainState>(
      builder: (context, state) {
        var isLightTheme = state.isLightTheme;
        return Scaffold(
          appBar: AppbarCustom(context, "Settings"),
          drawer: Drawer(
            child: MenuScreen(),
          ),
          body: Container(
            padding: EdgeInsets.fromLTRB(16, 48, 16, 16),
            child: Column(
              children: [
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text("Light theme"),
                  value: isLightTheme,
                  onChanged: (value) {
                    setState(() {
                      isLightTheme = value ?? true;
                      context.read<MainCubit>().setTheme(isLightTheme);
                    });
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
