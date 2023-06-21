import 'package:bloc/bloc.dart';
import 'package:donationapp/src/service/UpdateUserApi/update_api.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

part 'update_profile_state.dart';

class UpdateProfileCubit extends Cubit<UpdateProfileState> {
  UpdateProfileCubit() : super(UpdateProfileInitial(response: false));

  Future<bool> updateProfile(name,mobile,address)async{
    EasyLoading.show(status: "Please Wait...",dismissOnTap: false);
    UpdateProfileAPI api = UpdateProfileAPI();
    bool res  = await api.updateProfileAPI(name, address, mobile);
    if(res) {
      emit(UpdateProfileInitial(response: true));
      return true;
    }else{
      emit(UpdateProfileInitial(response: false));
      return false;
    }
  }
}
