import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:staff_management/common/enum/load_status.dart';
import 'package:staff_management/models/login.dart';
import 'package:staff_management/repositories/api.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final Api api;
  LoginCubit(this.api) : super(LoginState.init());

  Future<void> checkLogin(Login login) async {
    emit(state.copyWith(loadStatus: LoadStatus.loading));
    var result = await api.checkLogin(login);
    if(result){
      emit(state.copyWith(loadStatus: LoadStatus.done));
    } else{
      emit(state.copyWith(loadStatus: LoadStatus.error));
    }
}

}
