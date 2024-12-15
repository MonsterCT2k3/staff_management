import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  static const String route = 'NotificationScreen';

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
            "Statistical",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          //automaticallyImplyLeading: false,
          backgroundColor: Colors.red,
        ),
        body: Container(
          child: Column(
            children: [
              Notification(isAccept: true, beginDate: "7/12/2024", finishDate: "9/12/2024"),
              Notification(isAccept: false, beginDate: "9/12/2024", finishDate: '12/12/2024'),
              Notification(isAccept: true, beginDate: "7/12/2024", finishDate: "9/12/2024"),
              Notification(isAccept: false, beginDate: "9/12/2024", finishDate: '12/12/2024'),
              Notification(isAccept: false, beginDate: "9/12/2024", finishDate: '12/12/2024'),
            ],
          ),
        ));
  }
}

class Notification extends StatelessWidget {
  final bool isAccept;
  final String beginDate;
  final String finishDate;

  const Notification({required this.isAccept, required this.beginDate, required this.finishDate});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: isAccept ? Colors.green.shade100 : Colors.red.shade100,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  isAccept
                      ? Icon(
                          Icons.check,
                          color: Colors.green,
                        )
                      : Icon(
                          Icons.dangerous_outlined,
                          color: Colors.red,
                        ),
                  isAccept
                      ? Text(
                          "Admin đã chấp nhận đơn xin nghỉ của bạn",
                          style: TextStyle(color: Colors.green),
                        )
                      : Text(
                          "Admin đã từ chối đơn xin nghỉ của bạn",
                          style: TextStyle(color: Colors.red),
                        )
                ],
              ),
              Text(
                "Từ ngày ${beginDate} đến ngày ${finishDate}",
                style: isAccept ? TextStyle(color: Colors.green) : TextStyle(color: Colors.red),
              )
            ],
          ),
        ),
        SizedBox(
          height: 8,
        )
      ],
    );
  }
}
