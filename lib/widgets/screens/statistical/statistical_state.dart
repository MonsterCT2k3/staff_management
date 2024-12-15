part of 'statistical_cubit.dart';

class StatisticalState {
  final StatisticalEnum statisticalEnum;

  const StatisticalState.init({
    this.statisticalEnum = StatisticalEnum.month,
  });

//<editor-fold desc="Data Methods">
  const StatisticalState({
    required this.statisticalEnum,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StatisticalState && runtimeType == other.runtimeType && statisticalEnum == other.statisticalEnum);

  @override
  int get hashCode => statisticalEnum.hashCode;

  @override
  String toString() {
    return 'StatisticalState{' + ' statisticalEnum: $statisticalEnum,' + '}';
  }

  StatisticalState copyWith({
    StatisticalEnum? statisticalEnum,
  }) {
    return StatisticalState(
      statisticalEnum: statisticalEnum ?? this.statisticalEnum,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'statisticalEnum': this.statisticalEnum,
    };
  }

  factory StatisticalState.fromMap(Map<String, dynamic> map) {
    return StatisticalState(
      statisticalEnum: map['statisticalEnum'] as StatisticalEnum,
    );
  }

//</editor-fold>
}
