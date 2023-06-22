part of 'profile_cubit.dart';

abstract class ProfileState extends Equatable {
  final response;
  ProfileState({required this.response});
  @override
  List<Object> get props => [response];
}

class ProfileInitial extends ProfileState {
  ProfileInitial({required super.response});
}

class ProfileIdol extends ProfileState {
  ProfileIdol({required super.response});
}

class ProfileLoaded extends ProfileState {
  ProfileLoaded({required super.response});
}

class ProfileError extends ProfileState {
  ProfileError({required super.response});
}