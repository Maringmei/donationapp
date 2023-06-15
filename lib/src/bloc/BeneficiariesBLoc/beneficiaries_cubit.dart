import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../service/GenerateBenificariesListApi/generate_beneficiaries_api.dart';

part 'beneficiaries_state.dart';

class BeneficiariesCubit extends Cubit<BeneficiariesState> {
  BeneficiariesCubit() : super(BeneficiariesInitial(response: null));

  Future<dynamic> getBeneficiariesList(paymentID)async{
    EasyLoading.show(status: "Please Wait...");
    BenificiariesListAPI api = BenificiariesListAPI();
    dynamic res = await api.BenificiariesList(paymentID);
    if(res != false){
      EasyLoading.dismiss();
     return res;
    }else{
      EasyLoading.dismiss();
      EasyLoading.showToast("Errror on getting data.");
      return false;
    }
  }
}
