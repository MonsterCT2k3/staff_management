import 'package:bloc/bloc.dart';
import 'package:staff_management/common/enum/statistical_enum.dart';

part 'statistical_state.dart';

class StatisticalCubit extends Cubit<StatisticalState> {
  StatisticalCubit() : super(StatisticalState.init());

  void checkChart(StatisticalEnum statisticalEnum) {
    if (statisticalEnum == StatisticalEnum.month) {
      emit(state.copyWith(statisticalEnum: StatisticalEnum.month));
    } else if (statisticalEnum == StatisticalEnum.quarter) {
      emit(state.copyWith(statisticalEnum: StatisticalEnum.quarter));
    } else if (statisticalEnum == StatisticalEnum.year) {
      emit(state.copyWith(statisticalEnum: StatisticalEnum.year));
    }
  }
}
