import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../service/CreateAccount/createaccount.dart';

part 'createaccount_state.dart';

class CreateaccountCubit extends Cubit<CreateaccountState> {
  CreateaccountCubit() : super(CreateaccountInitial());

  Future<dynamic> createAccount(name, email, mobile, address, password)async{
    CreateAccountAPI api = CreateAccountAPI();
    final res = await api.CreateAccount(name, email, mobile, address, password);
    return res;
  }

}
