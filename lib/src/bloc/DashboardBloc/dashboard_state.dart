part of 'dashboard_cubit.dart';

abstract class DashboardState extends Equatable {
  dynamic response;
  DashboardState({this.response});

  @override
  List<Object> get props => [response];
}

class DashboardInitial extends DashboardState {
  DashboardInitial({required super.response});
}

class DashboardLoaded extends DashboardState {
  DashboardLoaded({required super.response});
}

