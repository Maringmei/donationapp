part of 'loginstatus_cubit.dart';

abstract class LoginstatusState extends Equatable {
  final loginStatus;
  LoginstatusState({required this.loginStatus});
  @override
  List<Object> get props => [loginStatus];
}

class LoginstatusInitial extends LoginstatusState {
  LoginstatusInitial({required super.loginStatus});
}
