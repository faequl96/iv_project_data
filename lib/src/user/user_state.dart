part of 'user_cubit.dart';

class UserState extends Equatable {
  const UserState({
    this.isLoadingGet = false,
    this.isLoadingGetById = false,
    this.isLoadingGets = false,
    this.isLoadingUpdateById = false,
    this.isLoadingDelete = false,
    this.isLoadingDeleteById = false,
    this.user,
    this.userById,
    this.users,
    this.usersBySearch,
    this.error,
  });

  final bool isLoadingGet;
  final bool isLoadingGetById;
  final bool isLoadingGets;
  final bool isLoadingUpdateById;
  final bool isLoadingDelete;
  final bool isLoadingDeleteById;
  final UserResponse? user;
  final UserResponse? userById;
  final List<UserResponse>? users;
  final List<UserResponse>? usersBySearch;

  final UserError? error;

  UserState copyWith({
    bool? isLoadingGet,
    bool? isLoadingGetById,
    bool? isLoadingGets,
    bool? isLoadingUpdateById,
    bool? isLoadingDelete,
    bool? isLoadingDeleteById,
    CopyWithValue<UserResponse?>? user,
    CopyWithValue<UserResponse?>? userById,
    CopyWithValue<List<UserResponse>?>? users,
    CopyWithValue<List<UserResponse>?>? usersBySearch,
    CopyWithValue<UserError?>? error,
  }) {
    return UserState(
      isLoadingGet: isLoadingGet ?? this.isLoadingGet,
      isLoadingGetById: isLoadingGetById ?? this.isLoadingGetById,
      isLoadingGets: isLoadingGets ?? this.isLoadingGets,
      isLoadingUpdateById: isLoadingUpdateById ?? this.isLoadingUpdateById,
      isLoadingDelete: isLoadingDelete ?? this.isLoadingDelete,
      isLoadingDeleteById: isLoadingDeleteById ?? this.isLoadingDeleteById,
      user: user != null ? user.value : this.user,
      userById: userById != null ? userById.value : this.userById,
      users: users != null ? users.value : this.users,
      usersBySearch: usersBySearch != null ? usersBySearch.value : this.usersBySearch,
      error: error != null ? error.value : this.error,
    );
  }

  void emitState() => GlobalContextService.value.read<UserCubit>().emitState(this);

  @override
  List<Object?> get props => [
    isLoadingGet,
    isLoadingGetById,
    isLoadingGets,
    isLoadingUpdateById,
    isLoadingDelete,
    isLoadingDeleteById,
    user,
    userById,
    users,
    usersBySearch,
    error,
  ];
}

enum UserErrorType { get, getById, gets, getsBySearch, updateById, delete, deleteById }

class UserError extends Equatable {
  const UserError.get(this.message) : type = UserErrorType.get;
  const UserError.getById(this.message) : type = UserErrorType.getById;
  const UserError.gets(this.message) : type = UserErrorType.gets;
  const UserError.getsBySearch(this.message) : type = UserErrorType.getsBySearch;
  const UserError.updateById(this.message) : type = UserErrorType.updateById;
  const UserError.delete(this.message) : type = UserErrorType.delete;
  const UserError.deleteById(this.message) : type = UserErrorType.deleteById;

  final UserErrorType type;
  final String message;

  @override
  List<Object?> get props => [type, message];
}
