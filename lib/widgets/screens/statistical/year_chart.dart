import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../repositories/api.dart';
import '../../../repositories/api_impl.dart';

// Di chuyển class MonthData ra ngoài
class MonthData {
  final int month;
  final int year;
  final List<int> data; // [onTime, late, absent]

  MonthData(this.month, this.year, this.data);

  String get monthYear => '$month/$year';
}

class YearChart extends StatefulWidget {
  @override
  State<YearChart> createState() => _YearChartState();
}

class _YearChartState extends State<YearChart> {
  Map<DateTime, String> _dayStatus = {};
  Api api = ApiImpl();
  List<MonthData> _monthlyData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _fetchAttendanceData();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  Future<void> _fetchAttendanceData() async {
    try {
      final List<Map<String, dynamic>>? attendanceData = await api.getEmployeeAttendance();

      if (attendanceData != null && attendanceData.isNotEmpty) {
        setState(() {
          final processedData = processAttendanceData(attendanceData);
          _dayStatus = processedData['dayStatus']!;
          _monthlyData = processLastTwelveMonths(_dayStatus);
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching attendance data: $e');
      setState(() {
        _isLoading = false;
      });
    }
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

  List<MonthData> processLastTwelveMonths(Map<DateTime, String> data) {
    List<MonthData> result = [];
    DateTime now = DateTime.now();

    // Tạo danh sách 12 tháng gần nhất
    for (int i = 0; i < 12; i++) {
      DateTime currentDate = DateTime(now.year, now.month - i);
      result.add(MonthData(currentDate.month, currentDate.year, [0, 0, 0]));
    }

    // Cập nhật dữ liệu
    for (var entry in data.entries) {
      // Chỉ xử lý dữ liệu trong phạm vi 12 tháng gần nhất
      DateTime monthStart = DateTime(now.year, now.month - 11, 1);
      if (entry.key.isAfter(monthStart) || entry.key.isAtSameMomentAs(monthStart)) {
        for (var monthData in result) {
          if (monthData.month == entry.key.month && monthData.year == entry.key.year) {
            switch (entry.value) {
              case 'onTime':
                monthData.data[0]++;
                break;
              case 'late':
                monthData.data[1]++;
                break;
              case 'absent':
                monthData.data[2]++;
                break;
            }
            break;
          }
        }
      }
    }

    // Sắp xếp từ tháng cũ đến tháng mới
    result.sort((a, b) {
      int yearCompare = a.year.compareTo(b.year);
      if (yearCompare != 0) return yearCompare;
      return a.month.compareTo(b.month);
    });

    return result;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_monthlyData.isEmpty) {
      return Center(child: Text('Không có dữ liệu'));
    }

    return Container(
      width: 800,
      height: 230,
      child: BarChart(
        BarChartData(
          barGroups: _getBarGroups(),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: TextStyle(fontSize: 12),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  int index = value.toInt();
                  if (index >= 0 && index < _monthlyData.length) {
                    return Text(
                      _monthlyData[index].monthYear,
                      style: TextStyle(fontSize: 12),
                    );
                  }
                  return Text('');
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: true),
          gridData: FlGridData(show: true),
          barTouchData: BarTouchData(enabled: true),
        ),
      ),
    );
  }

  List<BarChartGroupData> _getBarGroups() {
    return List.generate(_monthlyData.length, (index) {
      final monthData = _monthlyData[index].data;
      return BarChartGroupData(
        x: index,
        barRods: List.generate(
          monthData.length,
          (subIndex) => BarChartRodData(
            toY: monthData[subIndex].toDouble(),
            width: 10,
            color: _getBarColor(subIndex),
          ),
        ),
        barsSpace: 4,
      );
    });
  }

  Color _getBarColor(int index) {
    switch (index) {
      case 0:
        return Colors.green;
      case 1:
        return Colors.orange;
      case 2:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
