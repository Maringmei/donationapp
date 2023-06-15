import 'package:bloc/bloc.dart';
import 'package:donationapp/src/service/HistoryApi/history_api.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit() : super(HistoryInitial(response: null));

  void getHistory()async{
    EasyLoading.show(status: "Please Wait...",dismissOnTap: false);
    HistoryAPI api = HistoryAPI();
    dynamic res = await api.History();
    if(res != false){
      EasyLoading.dismiss();
      emit(HistoryLoaded(response: res));
    }else{
      EasyLoading.dismiss();
      EasyLoading.showToast("Error on getting data.");
    }
  }

  void refreshHistory(){
    emit(HistoryInitial(response: null));
  }
}
