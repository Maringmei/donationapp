part of 'pay_now_cubit.dart';

abstract class PayNowState extends Equatable {
  final response;
  PayNowState({required this.response});
  @override
  List<Object> get props => [];
}

class PayNowInitial extends PayNowState {PayNowInitial({required super.response});}
class PayNowSucess extends PayNowState {PayNowSucess({required super.response});}
class PayNowError extends PayNowState {PayNowError({required super.response});}
