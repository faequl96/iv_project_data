part of 'user_cubit.dart';

class UserState extends Equatable {
  const UserState({this.isLoadingGet = false, this.user, this.error});

  final bool isLoadingGet;
  final UserResponse? user;

  final UserError? error;

  UserState copyWith({bool? isLoadingGet, CopyWithValue<UserResponse?>? user, CopyWithValue<UserError?>? error}) {
    return UserState(
      isLoadingGet: isLoadingGet ?? this.isLoadingGet,
      user: user != null ? user.value : this.user,
      error: error != null ? error.value : this.error,
    );
  }

  void emitState() => GlobalContextService.value.read<UserCubit>().emitState(this);

  @override
  List<Object?> get props => [isLoadingGet, user, error];
}

enum UserErrorType { get }

class UserError extends Equatable {
  const UserError.get(this.message) : type = .get;

  final UserErrorType type;
  final String message;

  @override
  List<Object?> get props => [type, message];
}
