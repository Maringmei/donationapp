import 'package:bloc/bloc.dart';
import 'package:donationapp/src/service/ConfirmApi/confirm_api.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

part 'confirm_state.dart';

class ConfirmCubit extends Cubit<ConfirmState> {
  ConfirmCubit() : super(ConfirmInitial());

  Future<bool> confirmPayment(
      payment_id, payment_order_id, payment_signature) async {
    EasyLoading.show(status: "Please wait...",dismissOnTap: false);
    PaymentConfirmAPI api = PaymentConfirmAPI();
    var resData = await api.ConfirmPayNow(
        payment_id, payment_order_id, payment_signature);
    if(resData != false){
      EasyLoading.dismiss();
      return resData;
    }else{
      EasyLoading.dismiss();
     return resData;
    }
  }
}
