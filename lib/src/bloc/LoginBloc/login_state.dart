part of 'login_cubit.dart';

abstract class LoginState extends Equatable {
  final message;
  LoginState({required this.message});
  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {
  LoginInitial({required super.message});
}
class LoginLoaded extends LoginState {
  LoginLoaded({required super.message});
}

class LoginError extends LoginState {
  LoginError({required super.message});
}