import 'package:flutter/material.dart';
import 'package:staff_management/widgets/screens/notification/notification_screen.dart';

AppBar AppbarCustom(BuildContext context, String title) {
  return AppBar(
    leading: Builder(
      builder: (context) => IconButton(
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          icon: Icon(
            Icons.menu,
            color: Colors.white,
          )),
    ),
    title: Text(
      title,
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    actions: [
      IconButton(
        icon: Icon(
          Icons.notifications,
          color: Colors.white,
        ),
        onPressed: () {
          // Xử lý sự kiện khi nhấn vào nút thông báo
          Navigator.of(context).pushNamed(NotificationScreen.route);
        },
      ),
    ],

    //automaticallyImplyLeading: false,
    backgroundColor: Colors.red,
  );
}
