part of 'user_profile_cubit.dart';

class UserProfileState extends Equatable {
  const UserProfileState({
    this.isLoadingGet = false,
    this.isLoadingGetById = false,
    this.isLoadingUpdate = false,
    this.isLoadingUpdateById = false,
    this.userProfile,
    this.userProfileById,
    this.error,
  });

  final bool isLoadingGet;
  final bool isLoadingGetById;
  final bool isLoadingUpdate;
  final bool isLoadingUpdateById;
  final UserProfileResponse? userProfile;
  final UserProfileResponse? userProfileById;

  final UserProfileError? error;

  UserProfileState copyWith({
    bool? isLoadingGet,
    bool? isLoadingGetById,
    bool? isLoadingUpdate,
    bool? isLoadingUpdateById,
    CopyWithValue<UserProfileResponse?>? userProfile,
    CopyWithValue<UserProfileResponse?>? userProfileById,
    CopyWithValue<UserProfileError?>? error,
  }) {
    return UserProfileState(
      isLoadingGet: isLoadingGet ?? this.isLoadingGet,
      isLoadingGetById: isLoadingGetById ?? this.isLoadingGetById,
      isLoadingUpdate: isLoadingUpdate ?? this.isLoadingUpdate,
      isLoadingUpdateById: isLoadingUpdateById ?? this.isLoadingUpdateById,
      userProfile: userProfile != null ? userProfile.value : this.userProfile,
      userProfileById: userProfileById != null ? userProfileById.value : this.userProfileById,
      error: error != null ? error.value : this.error,
    );
  }

  void emitState() => GlobalContextService.value.read<UserProfileCubit>().emitState(this);

  @override
  List<Object?> get props => [
    isLoadingGet,
    isLoadingGetById,
    isLoadingUpdate,
    isLoadingUpdateById,
    userProfile,
    userProfileById,
    error,
  ];
}

enum UserProfileErrorType { get, getById, update, updateById }

class UserProfileError extends Equatable {
  const UserProfileError.get(this.message) : type = UserProfileErrorType.get;
  const UserProfileError.getById(this.message) : type = UserProfileErrorType.getById;
  const UserProfileError.update(this.message) : type = UserProfileErrorType.update;
  const UserProfileError.updateById(this.message) : type = UserProfileErrorType.updateById;

  final UserProfileErrorType type;
  final String message;

  @override
  List<Object?> get props => [type, message];
}
