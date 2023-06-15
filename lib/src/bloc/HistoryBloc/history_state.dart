part of 'history_cubit.dart';

abstract class HistoryState extends Equatable {
  final response;
  HistoryState({required this.response});
  @override
  List<Object> get props => [response];
}

class HistoryInitial extends HistoryState {
  HistoryInitial({required super.response});
}
class HistoryLoaded extends HistoryState {
  HistoryLoaded({required super.response});
}
class HistoryError extends HistoryState {
  HistoryError({required super.response});
}

