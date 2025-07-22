part of 'user_cubit.dart';

class UserUpdateRequest extends Equatable {
  const UserUpdateRequest({required this.role});

  final UserRoleType role;

  @override
  List<Object?> get props => [role];
}
