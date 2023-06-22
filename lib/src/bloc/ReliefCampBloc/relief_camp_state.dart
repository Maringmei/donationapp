part of 'relief_camp_cubit.dart';

abstract class ReliefCampState extends Equatable {
  final response;
  ReliefCampState({required this.response});
  @override
  List<Object> get props => [response];
}

class ReliefCampInitial extends ReliefCampState {
  ReliefCampInitial({required super.response});
}

class ReliefCampInitData extends ReliefCampState {
  ReliefCampInitData({required super.response});
}

class ReliefCampLoaded extends ReliefCampState {
  ReliefCampLoaded({required super.response});
}

class ReliefCampError extends ReliefCampState {
  ReliefCampError({required super.response});
}
