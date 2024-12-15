import 'package:bloc/bloc.dart';
import 'package:staff_management/models/employee.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState(employee: ));
}
