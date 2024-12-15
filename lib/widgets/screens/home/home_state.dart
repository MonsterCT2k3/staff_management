part of 'home_cubit.dart';

class HomeState {
  final Employee employee;

//<editor-fold desc="Data Methods">
  const HomeState({
    required this.employee,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is HomeState && runtimeType == other.runtimeType && employee == other.employee);

  @override
  int get hashCode => employee.hashCode;

  @override
  String toString() {
    return 'HomeState{' + ' employee: $employee,' + '}';
  }

  HomeState copyWith({
    Employee? employee,
  }) {
    return HomeState(
      employee: employee ?? this.employee,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'employee': this.employee,
    };
  }

  factory HomeState.fromMap(Map<String, dynamic> map) {
    return HomeState(
      employee: map['employee'] as Employee,
    );
  }

//</editor-fold>
}
