part of 'status_cubit.dart';

abstract class StatusState extends Equatable {
  final status;
  StatusState({required this.status});
  @override
  List<Object> get props => [status];
}

class StatusInitial extends StatusState {
  StatusInitial({required super.status});
}

class StatusDonate extends StatusState {
  StatusDonate({required super.status});
}

class StatusCreateAccount extends StatusState {
  StatusCreateAccount({required super.status});
}

class StatusLogin extends StatusState {
  StatusLogin({required super.status});
}

class StatusBenificiaries extends StatusState {
  StatusBenificiaries({required super.status});
}

class StatusProfile extends StatusState {
  StatusProfile({required super.status});
}

