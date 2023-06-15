import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'loginstatus_state.dart';

class LoginstatusCubit extends Cubit<LoginstatusState> {
  LoginstatusCubit() : super(LoginstatusInitial(loginStatus: false));

  void setLogin(){
    emit(LoginstatusInitial(loginStatus: true));
  }
  void setLogout(){
    emit(LoginstatusInitial(loginStatus: false));
  }
}
