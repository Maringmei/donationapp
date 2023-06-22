import 'package:bloc/bloc.dart';
import 'package:donationapp/src/service/ReliefCampApi/relief_camp_api.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

part 'relief_camp_state.dart';

class ReliefCampCubit extends Cubit<ReliefCampState> {
  ReliefCampCubit() : super(ReliefCampInitial(response: null));

  void getReliefCampList()async {
    EasyLoading.show(status: "Please Wait...",dismissOnTap: true);
    ReliefCampAPI api = ReliefCampAPI();
    var res = await api.getReliefCamp();
    if(res != false){
      emit(ReliefCampLoaded(response: res));
    } else{
      emit(ReliefCampError(response: null));
    }
  }
  void setInitData(){
    EasyLoading.showToast("r 1");
    getReliefCampList();
   emit(ReliefCampInitData(response: null));
  }
}
