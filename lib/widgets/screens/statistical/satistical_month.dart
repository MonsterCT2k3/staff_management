import 'package:flutter/material.dart';
import 'package:staff_management/repositories/api.dart';
import 'package:staff_management/repositories/api_impl.dart';
import 'package:table_calendar/table_calendar.dart';

class AttendanceCalendar extends StatelessWidget {
  final Map<DateTime, String> dayStatus;
  final Map<DateTime, String> timeInData;
  final DateTime focusedDay;
  final Function(DateTime, String?) onDaySelected;
  final Function(DateTime) onPageChanged;

  AttendanceCalendar({
    required this.dayStatus,
    required this.timeInData,
    required this.focusedDay,
    required this.onDaySelected,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: dayStatus.keys.reduce((a, b) => a.isBefore(b) ? a : b),
      // lastDay: dayStatus.keys.reduce((a, b) => a.isAfter(b) ? a : b),
      lastDay: DateTime.now(),
      focusedDay: focusedDay,
      onDaySelected: (selectedDay, _) {
        final normalizedDay = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
        onDaySelected(normalizedDay, timeInData[normalizedDay]);
      },
      onPageChanged: onPageChanged,
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, _) {
          return _buildCalendarDay(day);
        },
        selectedBuilder: (context, day, _) {
          return _buildCalendarDay(day);
        },
        todayBuilder: (context, day, _) {
          return _buildCalendarDay(day);
        },
      ),
      availableCalendarFormats: {
        CalendarFormat.month: 'Month',
      },
    );
  }

  Widget _buildCalendarDay(DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    String? status = dayStatus[normalizedDay];

    return GestureDetector(
      onTap: () => onDaySelected(normalizedDay, timeInData[normalizedDay]),
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            child: Text(
              '${day.day}',
              style: TextStyle(color: Colors.black),
            ),
          ),
          Container(
            height: 15,
            decoration: BoxDecoration(
              color: _getColorForStatus(status),
              shape: BoxShape.circle,
            ),
          )
        ],
      ),
    );
  }

  Color _getColorForStatus(String? status) {
    switch (status) {
      case "onTime":
        return Colors.green;
      case "late":
        return Colors.orange;
      case "absent":
        return Colors.red;
      default:
        return Colors.red;
    }
  }
}

class SatisticalMonth extends StatefulWidget {
  @override
  _SatisticalMonthState createState() => _SatisticalMonthState();
}

class _SatisticalMonthState extends State<SatisticalMonth> {
  Map<DateTime, String> _dayStatus = {};
  Map<DateTime, String> _timeInData = {};
  Api api = ApiImpl();

  DateTime? selectedDay;
  String? selectedTimeIn;
  DateTime focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchAttendanceData();
  }

  Future<void> _fetchAttendanceData() async {
    final List<Map<String, dynamic>>? attendanceData = await api.getEmployeeAttendance();
    // DateTime checkDay = normalizeDate(DateTime.parse(attendanceData?.last['date']));
    // if(checkDay.isBefore(DateTime.now())){
    //   attendanceData.add(value)
    // }
    setState(() {
      final processedData = processAttendanceData(attendanceData!);
      _dayStatus = processedData['dayStatus']!;
      _timeInData = processedData['timeInData']!;
    });
  }

  Map<String, Map<DateTime, String>> processAttendanceData(List<Map<String, dynamic>> attendanceData) {
    Map<DateTime, String> dayStatus = {};
    Map<DateTime, String> timeInData = {};

    for (var record in attendanceData) {
      DateTime date = normalizeDate(DateTime.parse(record['date']));
      DateTime timeIn = DateTime.parse('${record['date']} ${record['time_in']}');

      timeInData[date] = record['time_in'];

      if (timeIn.hour > 8 || (timeIn.hour == 8 && timeIn.minute > 30)) {
        dayStatus[date] = "late";
      } else {
        dayStatus[date] = "onTime";
      }
    }

    DateTime firstDate = normalizeDate(DateTime.parse(attendanceData.first['date']));
    DateTime lastDate = normalizeDate(DateTime.parse(attendanceData.last['date']));

    DateTime currentDate = firstDate;
    while (currentDate.isBefore(lastDate.add(Duration(days: 1)))) {
      if (!dayStatus.containsKey(currentDate)) {
        dayStatus[currentDate] = "absent";
      }
      currentDate = currentDate.add(Duration(days: 1));
    }

    return {
      'dayStatus': dayStatus,
      'timeInData': timeInData,
    };
  }

  DateTime normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_dayStatus.isNotEmpty)
          AttendanceCalendar(
            dayStatus: _dayStatus,
            timeInData: _timeInData,
            focusedDay: focusedDay,
            onDaySelected: (day, timeIn) {
              setState(() {
                selectedDay = day;
                selectedTimeIn = timeIn;
              });
            },
            onPageChanged: (newFocusedDay) {
              setState(() {
                focusedDay = newFocusedDay;
              });
            },
          )
        else
          CircularProgressIndicator(),
        SizedBox(height: 16),
        if (selectedDay != null)
          selectedTimeIn == null
              ? Text(
                  "Vắng Mặt",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )
              : Text(
                  'Ngày: ${selectedDay!.toLocal().toString().split(' ')[0]} - Giờ vào: $selectedTimeIn',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
      ],
    );
  }
}
