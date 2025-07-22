part of 'user_profile_cubit.dart';

class UserProfileUpdateRequest extends Equatable {
  const UserProfileUpdateRequest({this.firstName, this.lastName});

  final String? firstName;
  final String? lastName;

  @override
  List<Object?> get props => [firstName, lastName];
}
