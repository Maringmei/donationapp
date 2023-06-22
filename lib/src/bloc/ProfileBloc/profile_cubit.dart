import 'package:bloc/bloc.dart';
import 'package:donationapp/src/service/ProfileApi/profile_api.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial(response: null));

  Future<dynamic> getProfileData() async {
    EasyLoading.show(status: "Please Wait...",dismissOnTap: false);
    ProfileAPI api = ProfileAPI();
    var res = await api.getProfile();
    if (res != false) {
      emit(ProfileLoaded(response: res));
      return res;
    } else {
      return res;
    }
  }

  //for mobile
  void setProfile() {
    emit(ProfileInitial(response: null));
  }
}
