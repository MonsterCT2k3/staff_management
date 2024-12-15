import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:staff_management/common/enum/statistical_enum.dart';
import 'package:staff_management/widgets/screens/statistical/statistical_cubit.dart';

class StatisticalScreen extends StatelessWidget {
  static const String route = 'StatisticalScreen';

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
      body: BlocProvider(
        create: (context) => StatisticalCubit(),
        child: Page(),
      ),
    );
  }
}

class Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatisticalCubit, StatisticalState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Thống kê chấm công theo",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      DropdownExample(),
                    ],
                  ),
                ),
                state.statisticalEnum == StatisticalEnum.year
                    ? Container()
                    : SizedBox(
                        height: 40,
                      ),
                StatisticalChart(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class DropdownExample extends StatefulWidget {
  @override
  _DropdownExampleState createState() => _DropdownExampleState();
}

class _DropdownExampleState extends State<DropdownExample> {
  String? _selectedItem; // Biến lưu giá trị đã chọn
  final List<String> _items = ['Tháng', 'Quý ', 'Năm'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedItem = _items.first;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatisticalCubit, StatisticalState>(
      builder: (context, state) {
        return Center(
          child: DropdownButton<String>(
            value: _selectedItem, // Giá trị hiện tại
            items: _items.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: (value) {
              if (value == _items[0])
                context.read<StatisticalCubit>().checkChart(StatisticalEnum.month);
              else if (value == _items[1])
                context.read<StatisticalCubit>().checkChart(StatisticalEnum.quarter);
              else if (value == _items[2]) context.read<StatisticalCubit>().checkChart(StatisticalEnum.year);
              setState(() {
                _selectedItem = value; // Cập nhật giá trị khi chọn
              });
            },
          ),
        );
      },
    );
  }
}

class StatisticalChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatisticalCubit, StatisticalState>(
      builder: (context, state) {
        if (state.statisticalEnum == StatisticalEnum.month)
          return MonthChart();
        else if (state.statisticalEnum == StatisticalEnum.quarter)
          return QuarterChart();
        else
          return YearChart();
      },
    );
  }
}

class MonthChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 32,
        ),
        Container(
          width: 100,
          height: 100,
          child: PieChart(
            PieChartData(
              sections: _getSections(),
              centerSpaceRadius: 40, // Khoảng trống ở giữa
              sectionsSpace: 2, // Khoảng cách giữa các phần
            ),
          ),
        ),
        SizedBox(
          width: 80,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 10,
                  width: 10,
                  color: Colors.green,
                ),
                SizedBox(
                  width: 8,
                ),
                Text("Đi làm đúng giờ")
              ],
            ),
            Row(
              children: [
                Container(
                  height: 10,
                  width: 10,
                  color: Colors.orange,
                ),
                SizedBox(
                  width: 8,
                ),
                Text("Đi làm muộn")
              ],
            ),
            Row(
              children: [
                Container(
                  height: 10,
                  width: 10,
                  color: Colors.red,
                ),
                SizedBox(
                  width: 8,
                ),
                Text("Nghỉ")
              ],
            ),
          ],
        )
      ],
    );
  }

  List<PieChartSectionData> _getSections() {
    final data = [22, 3, 1]; // Giá trị các phần
    final total = data.reduce((a, b) => a + b); // Tổng giá trị

    return List.generate(data.length, (index) {
      final value = data[index].toDouble();
      final percentage = (value / total * 100).toStringAsFixed(1); // Tính phần trăm
      return PieChartSectionData(
        value: value,
        color: _getColor(index),
        // Lấy màu tương ứng
        title: '${value.toInt()} ngày',
        // Hiển thị phần trăm
        radius: 50,
        titleStyle: TextStyle(color: Colors.black, fontSize: 16),
      );
    });
  }

  Color _getColor(int index) {
    // Màu sắc cho từng phần
    const colors = [Colors.green, Colors.orange, Colors.red];
    return colors[index % colors.length];
  }
}

class QuarterChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                    value.toInt().toString(), // Hiển thị giá trị trên trục Y
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
                        'Tháng 1',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      );
                    case 1:
                      return Text(
                        'Tháng 2',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      );
                    case 2:
                      return Text(
                        'Tháng 3',
                        style: TextStyle(fontWeight: FontWeight.bold),
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
          barTouchData: BarTouchData(enabled: true), // Hiệu ứng chạm
        ),
      ),
    );
  }

  List<BarChartGroupData> _getBarGroups() {
    // Dữ liệu cho mỗi tháng
    final data = [
      [20.0, 5.0, 3.0], // Tháng 1: Đúng giờ, Muộn, Nghỉ
      [18.0, 7.0, 2.0], // Tháng 2
      [22.0, 4.0, 1.0], // Tháng 3
    ];

    return List.generate(data.length, (index) {
      final monthData = data[index];
      return BarChartGroupData(
        x: index,
        barRods: List.generate(
          monthData.length,
          (subIndex) => BarChartRodData(
            toY: monthData[subIndex], // Giá trị cột
            width: 10, // Độ rộng cột
            color: _getBarColor(subIndex), // Màu sắc cho từng loại
          ),
        ),
        barsSpace: 4, // Khoảng cách giữa các cột trong cùng một tháng
      );
    });
  }

  // Hàm lấy màu sắc cho từng loại
  Color _getBarColor(int index) {
    switch (index) {
      case 0:
        return Colors.green; // Đi làm đúng giờ
      case 1:
        return Colors.orange; // Đi làm muộn
      case 2:
        return Colors.red; // Nghỉ
      default:
        return Colors.grey;
    }
  }
}

class YearChart extends StatefulWidget {
  @override
  State<YearChart> createState() => _YearChartState();
}

class _YearChartState extends State<YearChart> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    value.toInt().toString(), // Hiển thị giá trị trên trục Y
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
                        'Tháng 1',
                        style: TextStyle(fontSize: 12),
                      );
                    case 1:
                      return Text(
                        'Tháng 2',
                        style: TextStyle(fontSize: 12),
                      );
                    case 2:
                      return Text(
                        'Tháng 3',
                        style: TextStyle(fontSize: 12),
                      );
                    case 3:
                      return Text(
                        'Tháng 4',
                        style: TextStyle(fontSize: 12),
                      );
                    case 4:
                      return Text(
                        'Tháng 5',
                        style: TextStyle(fontSize: 12),
                      );
                    case 5:
                      return Text(
                        'Tháng 6',
                        style: TextStyle(fontSize: 12),
                      );
                    case 6:
                      return Text(
                        'Tháng 7',
                        style: TextStyle(fontSize: 12),
                      );
                    case 7:
                      return Text(
                        'Tháng 8',
                        style: TextStyle(fontSize: 12),
                      );
                    case 8:
                      return Text(
                        'Tháng 9',
                        style: TextStyle(fontSize: 12),
                      );
                    case 9:
                      return Text(
                        'Tháng 10',
                        style: TextStyle(fontSize: 12),
                      );
                    case 10:
                      return Text(
                        'Tháng 11',
                        style: TextStyle(fontSize: 12),
                      );
                    case 11:
                      return Text(
                        'Tháng 12',
                        style: TextStyle(fontSize: 12),
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
          barTouchData: BarTouchData(enabled: true), // Hiệu ứng chạm
        ),
      ),
    );
  }

  List<BarChartGroupData> _getBarGroups() {
    // Dữ liệu cho mỗi tháng
    final data = [
      [20, 5, 3], // Tháng 1
      [18, 7, 2], // Tháng 2
      [22, 4, 1], // Tháng 3
      [25, 3, 0], // Tháng 4
      [23, 6, 1], // Tháng 5
      [19, 8, 2], // Tháng 6
      [21, 5, 1], // Tháng 7
      [20, 4, 3], // Tháng 8
      [24, 2, 0], // Tháng 9
      [22, 3, 2], // Tháng 10
      [18, 6, 4], // Tháng 11
      [25, 2, 0], // Tháng 12
    ];

    return List.generate(data.length, (index) {
      final monthData = data[index];
      return BarChartGroupData(
        x: index,
        barRods: List.generate(
          monthData.length,
          (subIndex) => BarChartRodData(
            toY: monthData[subIndex].toDouble(), // Giá trị cột
            width: 10, // Độ rộng cột
            color: _getBarColor(subIndex), // Màu sắc cho từng loại
          ),
        ),
        barsSpace: 4, // Khoảng cách giữa các cột trong cùng một tháng
      );
    });
  }

  // Hàm lấy màu sắc cho từng loại
  Color _getBarColor(int index) {
    switch (index) {
      case 0:
        return Colors.green; // Đi làm đúng giờ
      case 1:
        return Colors.orange; // Đi làm muộn
      case 2:
        return Colors.red; // Nghỉ
      default:
        return Colors.grey;
    }
  }
}
