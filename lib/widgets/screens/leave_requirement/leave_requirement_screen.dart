import 'package:flutter/material.dart';
import 'package:staff_management/repositories/api.dart';
import 'package:staff_management/repositories/api_impl.dart';
import 'package:staff_management/widgets/screens/status_requirement/status_requirement_screen.dart';

import '../../common_widgets/noti_bar.dart';

class LeaveRequirementScreen extends StatefulWidget {
  static const String route = "LeaveRequirementScreen";

  @override
  State<LeaveRequirementScreen> createState() => _LeaveRequirementScreenState();
}

class _LeaveRequirementScreenState extends State<LeaveRequirementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  String? _leaveType;
  DateTime? _startDate;
  DateTime? _endDate;
  Api _api = ApiImpl();

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_startDate == null || _endDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Vui lòng chọn ngày bắt đầu và ngày kết thúc')),
        );
        return;
      }

      final currentDate = DateTime.now();
      final minStartDate = currentDate.add(Duration(days: 2));

      // Kiểm tra ràng buộc ngày
      if (_startDate!.isBefore(minStartDate)) {
        ScaffoldMessenger.of(context).showSnackBar(notiBar("Ngày bắt đầu phải lớn hơn ngày hiện tại 3 ngày", true));
        return;
      }

      if (_endDate!.isBefore(_startDate!)) {
        ScaffoldMessenger.of(context).showSnackBar(notiBar("Ngày kết thúc phải lớn hơn hoặc bằng ngày hiện tại", true));
        return;
      }

      // Logic gửi đơn xin nghỉ phép (tạm thời in ra console)
      print('Nộp đơn xin nghỉ phép:');
      print('Loại nghỉ phép: ${_leaveType.toString()}');
      print('Ngày bắt đầu: ${_startDate.toString().substring(0, 10)}');
      print('Ngày kết thúc: ${_endDate.toString().substring(0, 10)}');
      print('Lý do: ${_reasonController.text}');

      FocusScope.of(context).unfocus();
      try {
        final checkLeaveRequest = await _api.leaveRequirement(
          _startDate.toString().substring(0, 10),
          _endDate.toString().substring(0, 10),
          _leaveType.toString(),
          _reasonController.text,
        );
        if (checkLeaveRequest == true) {
          ScaffoldMessenger.of(context).showSnackBar(notiBar("Sent Request Success", false));
          Navigator.of(context).pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(notiBar("Sent Request Failed", true));
        }
        await Future.delayed(Duration(milliseconds: 200));
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
            "Leave requirement",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          //automaticallyImplyLeading: false,
          backgroundColor: Colors.red,
        ),
        body: Column(
          children: [
            SizedBox(
              height: 16,
            ),
            ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pushNamed(StatusRequirementScreen.route);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [Icon(Icons.list_alt), Text("Xem tình trạng đơn")],
                )),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(labelText: 'Loại nghỉ phép'),
                        value: _leaveType,
                        items: [
                          DropdownMenuItem(value: 'Nghỉ phép năm', child: Text('Nghỉ phép năm')),
                          DropdownMenuItem(value: 'Nghỉ bệnh', child: Text('Nghỉ bệnh')),
                          DropdownMenuItem(value: 'Nghỉ không lương', child: Text('Nghỉ không lương')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _leaveType = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Vui lòng chọn loại nghỉ phép';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      Column(
                        children: [
                          Container(
                            width: 200,
                            child: ElevatedButton(
                              onPressed: () => _selectDate(context, true),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(_startDate == null ? '' : 'Bắt đầu: '),
                                  Text(_startDate == null
                                      ? 'Chọn ngày bắt đầu'
                                      : "${_startDate!.toLocal()}".split(' ')[0]),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            width: 200,
                            child: ElevatedButton(
                              onPressed: () => _selectDate(context, false),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(_endDate == null ? '' : 'Kết thúc: '),
                                  Text(
                                      _endDate == null ? 'Chọn ngày kết thúc' : '${_endDate!.toLocal()}'.split(' ')[0]),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      // SizedBox(height:),
                      TextFormField(
                        controller: _reasonController,
                        decoration: InputDecoration(labelText: 'Lý do nghỉ phép'),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập lý do nghỉ phép';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _submitForm,
                        child: Text('Nộp đơn'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
