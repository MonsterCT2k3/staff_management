class LeaveRequest {
  final int id;
  final String startDate;
  final String endDate;
  final String requestDate;
  final String requestType;
  final String reason;
  final String status;

  LeaveRequest({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.requestDate,
    required this.requestType,
    required this.reason,
    required this.status,
  });

  factory LeaveRequest.fromJson(Map<String, dynamic> json) {
    return LeaveRequest(
      id: json['id'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      requestDate: json['request_date'],
      requestType: json['request_type'],
      reason: json['reason'],
      status: json['status'],
    );
  }
}
