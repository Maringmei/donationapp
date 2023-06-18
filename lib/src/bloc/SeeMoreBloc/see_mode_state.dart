part of 'see_mode_cubit.dart';

abstract class SeeModeState extends Equatable {
  final response;
  SeeModeState({required this.response});
  @override
  List<Object> get props => [response];
}

class SeeModeInitial extends SeeModeState {
  SeeModeInitial({required super.response});
}
class SeeModeLoaded extends SeeModeState {
  SeeModeLoaded({required super.response});
}

class SeeModeError extends SeeModeState {
  SeeModeError({required super.response});
}



