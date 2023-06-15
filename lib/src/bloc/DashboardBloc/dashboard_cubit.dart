import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../service/DashboardApi/dashboard_api.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(DashboardInitial(response: null));

  void getDashboard()async{
    DashboardAPI api = DashboardAPI();
    var res = await api.dashboard();
    if(res != false){
      emit(DashboardLoaded(response: res));
    }else{
      emit(DashboardError(response: null));
      EasyLoading.showToast("Error on getting data");
    }
  }

  void refreshDashboard(){
    emit(DashboardInitial(response: null));
  }
}
