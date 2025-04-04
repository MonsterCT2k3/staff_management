

void main() {
  // Dữ liệu mẫu, bạn có thể thay đổi theo dữ liệu thực tế
  Map<DateTime, String> attendanceData = {
    DateTime(2024, 10, 1): 'onTime',
    DateTime(2024, 10, 4): 'onTime',
    DateTime(2024, 10, 7): 'onTime',
    DateTime(2024, 10, 10): 'onTime',
    DateTime(2024, 10, 13): 'onTime',
    DateTime(2024, 10, 16): 'onTime',
    DateTime(2024, 10, 19): 'onTime',
    DateTime(2024, 10, 22): 'late',
    DateTime(2024, 10, 25): 'onTime',
    DateTime(2024, 10, 28): 'late',
    DateTime(2024, 10, 31): 'onTime',
    DateTime(2024, 11, 3): 'late',
    DateTime(2024, 11, 6): 'onTime',
    DateTime(2024, 11, 9): 'late',
    DateTime(2024, 11, 12): 'onTime',
    DateTime(2024, 11, 15): 'onTime',
    DateTime(2024, 12, 1): 'onTime',
    DateTime(2024, 12, 4): 'onTime',
    DateTime(2024, 12, 7): 'onTime',
    DateTime(2024, 12, 10): 'onTime',
    DateTime(2024, 12, 13): 'onTime',
    DateTime(2024, 12, 16): 'late',
    DateTime(2024, 12, 19): 'onTime',
    DateTime(2024, 12, 22): 'onTime',
    DateTime(2024, 12, 25): 'onTime',
    DateTime(2024, 12, 28): 'late',
    DateTime(2024, 12, 31): 'onTime',
    DateTime(2024, 10, 2): 'absent',
    DateTime(2024, 10, 3): 'absent',
    DateTime(2024, 10, 5): 'absent',
    DateTime(2024, 10, 6): 'absent',
    DateTime(2024, 10, 8): 'absent',
    DateTime(2024, 10, 9): 'absent',
    DateTime(2024, 10, 11): 'absent',
    DateTime(2024, 10, 12): 'absent',
    DateTime(2024, 10, 14): 'absent',
    DateTime(2024, 10, 15): 'absent',
    DateTime(2024, 10, 17): 'absent',
    DateTime(2024, 10, 18): 'absent',
    DateTime(2024, 10, 20): 'absent',
    DateTime(2024, 10, 21): 'absent',
    DateTime(2024, 10, 23): 'absent',
    DateTime(2024, 10, 24): 'absent',
    DateTime(2024, 10, 26): 'absent',
    DateTime(2024, 10, 27): 'absent',
    DateTime(2024, 10, 29): 'absent',
    DateTime(2024, 10, 30): 'absent',
  };

  // Hàm lọc dữ liệu
  Map<int, List<int>> filterLastThreeMonths(Map<DateTime, String> data) {
    DateTime now = DateTime.now();
    DateTime threeMonthsAgo = DateTime(now.year, now.month - 3, now.day);

    // Lọc dữ liệu của 3 tháng gần nhất
    Map<int, List<int>> result = {};
    for (var entry in data.entries) {
      if (entry.key.isAfter(threeMonthsAgo)) {
        int month = entry.key.month;
        if (!result.containsKey(month)) {
          result[month] = [0, 0, 0]; // onTime, late, absent
        }

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

    // Trả về kết quả
    return result;
  }

  // Lọc 3 tháng gần nhất
  var result = filterLastThreeMonths(attendanceData);
  for (var month in result.keys) {
    print("Tháng $month: ${result[month]}");
  }
}
