import 'package:bloc/bloc.dart';
import 'package:donationapp/src/service/PayApi/pay_api.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

part 'pay_now_state.dart';

class PayNowCubit extends Cubit<PayNowState> {
  PayNowCubit() : super(PayNowInitial(response: {}));

  Future<dynamic> PayNow(amount) async {
    EasyLoading.show(status: "Please wait...",dismissOnTap: false);
    PayAPI api = PayAPI();
    var resData = await api.PayNow(amount);
    if (resData == false){
    } else {
      EasyLoading.dismiss();
      return resData;
    }
  }
}
