import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../service/SeeMoreApi/seemore_api.dart';

part 'see_mode_state.dart';

class SeeModeCubit extends Cubit<SeeModeState> {
  SeeModeCubit() : super(SeeModeInitial(response: null));

  void getSeeMore()async{
    EasyLoading.show(status: "Please Wait...",dismissOnTap: false);
    SeeMoreAPI api = SeeMoreAPI();
    var res = await api.getSeeMore();
    if(res != false){
      print(res);
      emit(SeeModeLoaded(response: res));
    }
    else{
      EasyLoading.dismiss();
      emit(SeeModeError(response: null));
    }
  }

  void seemoreRefresh()async{
      emit(SeeModeInitial(response: null));
  }
}
