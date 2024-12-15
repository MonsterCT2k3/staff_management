import 'package:flutter/material.dart';
import 'package:staff_management/models/leave_request.dart';
import 'package:staff_management/repositories/api.dart';
import 'package:staff_management/repositories/api_impl.dart';

class StatusRequirementScreen extends StatefulWidget {
  static const String route = 'StatusRequirementScreen';

  const StatusRequirementScreen({super.key});

  @override
  State<StatusRequirementScreen> createState() => _StatusRequirementScreenState();
}

class _StatusRequirementScreenState extends State<StatusRequirementScreen> {
  List<LeaveRequest>? _leaveRequests;
  Api _api = ApiImpl();

  Future<void> _fetchLeaveRequests() async {
    final response = await _api.getEmployeeLeaveRequests();
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
  void initState() {
    _fetchLeaveRequests();
  }

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
          "Status Leave Requirement",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        //automaticallyImplyLeading: false,
        backgroundColor: Colors.red,
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
