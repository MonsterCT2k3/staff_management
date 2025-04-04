import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:staff_management/common/enum/statistical_enum.dart';
import 'package:staff_management/widgets/screens/statistical/quarter_chart.dart';
import 'package:staff_management/widgets/screens/statistical/satistical_month.dart';
import 'package:staff_management/widgets/screens/statistical/statistical_cubit.dart';
import 'package:staff_management/widgets/screens/statistical/year_chart.dart';

class StatisticalScreen extends StatelessWidget {
  static const String route = 'StatisticalScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () async {
              var orientation = MediaQuery.of(context).orientation;
              // Nếu màn hình xoay ngang, đặt lại hướng sang dọc
              if (orientation == Orientation.landscape) {
                await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
              }
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
                        "Thống kê chấm công trong",
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
  final List<String> _items = ['Tháng', '3 tháng', 'Năm'];

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
          return SatisticalMonth();
        else if (state.statisticalEnum == StatisticalEnum.quarter)
          return QuarterChart();
        else
          return YearChart();
      },
    );
  }
}

// class MonthChart extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         SizedBox(
//           width: 32,
//         ),
//         Container(
//           width: 100,
//           height: 100,
//           child: PieChart(
//             PieChartData(
//               sections: _getSections(),
//               centerSpaceRadius: 40, // Khoảng trống ở giữa
//               sectionsSpace: 2, // Khoảng cách giữa các phần
//             ),
//           ),
//         ),
//         SizedBox(
//           width: 80,
//         ),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Container(
//                   height: 10,
//                   width: 10,
//                   color: Colors.green,
//                 ),
//                 SizedBox(
//                   width: 8,
//                 ),
//                 Text("Đi làm đúng giờ")
//               ],
//             ),
//             Row(
//               children: [
//                 Container(
//                   height: 10,
//                   width: 10,
//                   color: Colors.orange,
//                 ),
//                 SizedBox(
//                   width: 8,
//                 ),
//                 Text("Đi làm muộn")
//               ],
//             ),
//             Row(
//               children: [
//                 Container(
//                   height: 10,
//                   width: 10,
//                   color: Colors.red,
//                 ),
//                 SizedBox(
//                   width: 8,
//                 ),
//                 Text("Nghỉ")
//               ],
//             ),
//           ],
//         )
//       ],
//     );
//   }
//
//   List<PieChartSectionData> _getSections() {
//     final data = [22, 3, 1]; // Giá trị các phần
//     final total = data.reduce((a, b) => a + b); // Tổng giá trị
//
//     return List.generate(data.length, (index) {
//       final value = data[index].toDouble();
//       final percentage = (value / total * 100).toStringAsFixed(1); // Tính phần trăm
//       return PieChartSectionData(
//         value: value,
//         color: _getColor(index),
//         // Lấy màu tương ứng
//         title: '${value.toInt()} ngày',
//         // Hiển thị phần trăm
//         radius: 50,
//         titleStyle: TextStyle(color: Colors.black, fontSize: 16),
//       );
//     });
//   }
//
//   Color _getColor(int index) {
//     // Màu sắc cho từng phần
//     const colors = [Colors.green, Colors.orange, Colors.red];
//     return colors[index % colors.length];
//   }
// }
