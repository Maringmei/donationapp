part of 'update_profile_cubit.dart';

abstract class UpdateProfileState extends Equatable {
  final response;
  UpdateProfileState({required this.response});
  @override
  List<Object> get props => [response];
}

class UpdateProfileInitial extends UpdateProfileState {
  UpdateProfileInitial({required super.response});}
