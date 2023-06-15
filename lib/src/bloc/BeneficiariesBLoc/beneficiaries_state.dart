part of 'beneficiaries_cubit.dart';

abstract class BeneficiariesState extends Equatable {
  final response;
  BeneficiariesState({required this.response});
  @override
  List<Object> get props => [response];
}

class BeneficiariesInitial extends BeneficiariesState {BeneficiariesInitial({required super.response});}
