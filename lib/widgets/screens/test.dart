import 'package:flutter/material.dart';

import 'api_impl.dart';
import 'leave_request.dart';

class LeaveRequestScreen extends StatefulWidget {
  final String employeeId;

  const LeaveRequestScreen({Key? key, required this.employeeId}) : super(key: key);

  @override
  State<LeaveRequestScreen> createState() => _LeaveRequestScreenState();
}

class _LeaveRequestScreenState extends State<LeaveRequestScreen> {
  List<LeaveRequest>? _leaveRequests;
  final ApiImpl _api = ApiImpl();

  @override
  void initState() {
    super.initState();
    _fetchLeaveRequests();
  }

  Future<void> _fetchLeaveRequests() async {
    final response = await _api.getEmployeeLeaveRequests(widget.employeeId);
    if (response != null) {
      setState(() {
        _leaveRequests = response.map((data) => LeaveRequest.fromJson(data)).toList();
      });
    } else {
      setState(() {
        _leaveRequests = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách đơn xin nghỉ'),
      ),
      body: _leaveRequests == null
          ? Center(child: CircularProgressIndicator())
          : _leaveRequests!.isEmpty
              ? Center(child: Text('Không có đơn xin nghỉ nào'))
              : ListView.builder(
                  itemCount: _leaveRequests!.length,
                  itemBuilder: (context, index) {
                    final request = _leaveRequests![index];
                    return Card(
                      margin: EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text('${request.requestType}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Từ: ${request.startDate} - Đến: ${request.endDate}'),
                            Text('Lý do: ${request.reason}'),
                            Text('Trạng thái: ${request.status}'),
                          ],
                        ),
                        trailing: Icon(
                          request.status == 'Approved'
                              ? Icons.check_circle
                              : request.status == 'Rejected'
                                  ? Icons.cancel
                                  : Icons.hourglass_empty,
                          color: request.status == 'Approved'
                              ? Colors.green
                              : request.status == 'Rejected'
                                  ? Colors.red
                                  : Colors.orange,
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
