import 'package:donationapp/src/bloc/CreateAccountBloc/createaccount_cubit.dart';
import 'package:donationapp/src/bloc/DashboardBloc/dashboard_cubit.dart';
import 'package:donationapp/src/bloc/LoginBloc/login_cubit.dart';
import 'package:donationapp/src/bloc/LoginStatus/loginstatus_cubit.dart';
import 'package:donationapp/src/bloc/PayNowBloc/pay_now_cubit.dart';
import 'package:donationapp/src/bloc/ReliefCampBloc/relief_camp_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../BeneficiariesBLoc/beneficiaries_cubit.dart';
import '../ConfirmBloc/confirm_cubit.dart';
import '../HistoryBloc/history_cubit.dart';
import '../ProfileBloc/profile_cubit.dart';
import '../SeeMoreBloc/see_mode_cubit.dart';
import '../StatusBloc/status_cubit.dart';
import '../UpdateProfileBloc/update_profile_cubit.dart';

class MultiBloc extends StatelessWidget {
  final widgets;
  MultiBloc({Key? key, required this.widgets}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
        create: (context) => StatusCubit(),
      ),
      BlocProvider(
        create: (context) => LoginCubit(),
      ),
      BlocProvider(
        create: (context) => CreateaccountCubit(),
      ),
      BlocProvider(
        create: (context) => PayNowCubit(),
      ),
      BlocProvider(
        create: (context) => ConfirmCubit(),
      ),
      BlocProvider(
        create: (context) => LoginstatusCubit(),
      ),
      BlocProvider(
        create: (context) => DashboardCubit(),
      ),
      BlocProvider(
        create: (context) => BeneficiariesCubit(),
      ),
      BlocProvider(
        create: (context) => HistoryCubit(),
      ),
      BlocProvider(
        create: (context) => SeeModeCubit(),
      ),
      BlocProvider(
        create: (context) => ProfileCubit(),
      ),
      BlocProvider(
        create: (context) => UpdateProfileCubit(),
      ),
      BlocProvider(
        create: (context) => ReliefCampCubit(),
      ),

    ], child: widgets);
  }
}
