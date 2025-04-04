import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../repositories/api.dart';
import '../../../repositories/api_impl.dart';

class QuarterChart extends StatefulWidget {
  @override
  State<QuarterChart> createState() => _QuarterChartState();
}

class _QuarterChartState extends State<QuarterChart> {
  Map<DateTime, String> _dayStatus = {};
  Api api = ApiImpl();
  Map<int, List<int>> _dataChart = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAttendanceData();
  }

  Future<void> _fetchAttendanceData() async {
    try {
      final List<Map<String, dynamic>>? attendanceData = await api.getEmployeeAttendance();

      if (attendanceData != null && attendanceData.isNotEmpty) {
        setState(() {
          final processedData = processAttendanceData(attendanceData);
          _dayStatus = processedData['dayStatus']!;
          _dataChart = filterLastThreeMonths(_dayStatus);
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

  Map<int, List<int>> filterLastThreeMonths(Map<DateTime, String> data) {
    DateTime now = DateTime.now();
    DateTime threeMonthsAgo = DateTime(now.year, now.month - 3, now.day);

    Map<int, List<int>> result = {};

    // Khởi tạo dữ liệu cho 3 tháng gần nhất
    int currentMonth = now.month;
    for (int i = 0; i < 3; i++) {
      int month = currentMonth - i;
      if (month <= 0) month += 12;
      result[month] = [0, 0, 0]; // onTime, late, absent
    }

    // Cập nhật dữ liệu từ attendance
    for (var entry in data.entries) {
      if (entry.key.isAfter(threeMonthsAgo)) {
        int month = entry.key.month;
        if (result.containsKey(month)) {
          switch (entry.value) {
            case 'onTime':
              result[month]![0]++;
              break;
            case 'late':
              result[month]![1]++;
              break;
            case 'absent':
              result[month]![2]++;
              break;
          }
        }
      }
    }

    return result;
  }

  List<BarChartGroupData> _getBarGroups() {
    if (_dataChart.isEmpty) {
      return [];
    }

    List<MapEntry<int, List<int>>> sortedEntries = _dataChart.entries.toList();
    var thirdMonth = sortedEntries.last;
    sortedEntries.last = sortedEntries.first;
    sortedEntries.first = thirdMonth;
    return List.generate(sortedEntries.length, (index) {
      final monthData = sortedEntries[index].value.map((e) => e.toDouble()).toList();
      return BarChartGroupData(
        x: index,
        barRods: List.generate(
          monthData.length,
          (subIndex) => BarChartRodData(
            toY: monthData[subIndex],
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_dataChart.isEmpty) {
      return Center(child: Text('Không có dữ liệu'));
    }

    int currentMonth = DateTime.now().month;
    int previousMonth = currentMonth - 1;
    int previous2Month = currentMonth - 2;
    if (previousMonth <= 0) previousMonth += 12;
    if (previous2Month <= 0) previous2Month += 12;

    return Container(
      height: 400,
      width: 300,
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
                  switch (value.toInt()) {
                    case 0:
                      return Text(
                        'Tháng $previous2Month',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      );
                    case 1:
                      return Text(
                        'Tháng $previousMonth',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      );
                    case 2:
                      return Text(
                        'Tháng $currentMonth',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      );
                    default:
                      return Text('');
                  }
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
}
