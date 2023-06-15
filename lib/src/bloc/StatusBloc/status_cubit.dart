import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'status_state.dart';

class StatusCubit extends Cubit<StatusState> {
  StatusCubit() : super(StatusInitial(status: 0));

  void setDonate(){
    emit(StatusDonate(status: 0));
  }
  void setCreateAccount(){
    emit(StatusCreateAccount(status: 1));
  }
  void setLogin(){
    emit(StatusLogin(status: 2));
  }
  void setBenificiaries(){
    emit(StatusBenificiaries(status: 3));
  }
}
