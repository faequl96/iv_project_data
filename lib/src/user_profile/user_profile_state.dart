part of 'user_profile_cubit.dart';

class UserProfileState extends Equatable {
  const UserProfileState({this.isLoadingGet = false, this.isLoadingUpdate = false, this.userProfile, this.error});

  final bool isLoadingGet;
  final bool isLoadingUpdate;
  final UserProfileResponse? userProfile;

  final UserProfileError? error;

  UserProfileState copyWith({
    bool? isLoadingGet,
    bool? isLoadingUpdate,
    CopyWithValue<UserProfileResponse?>? userProfile,
    CopyWithValue<UserProfileError?>? error,
  }) {
    return UserProfileState(
      isLoadingGet: isLoadingGet ?? this.isLoadingGet,
      isLoadingUpdate: isLoadingUpdate ?? this.isLoadingUpdate,
      userProfile: userProfile != null ? userProfile.value : this.userProfile,
      error: error != null ? error.value : this.error,
    );
  }

  void emitState() => GlobalContextService.value.read<UserProfileCubit>().emitState(this);

  @override
  List<Object?> get props => [isLoadingGet, isLoadingUpdate, userProfile, error];
}

enum UserProfileErrorType { get, update }

class UserProfileError extends Equatable {
  const UserProfileError.get(this.message) : type = .get;
  const UserProfileError.update(this.message) : type = .update;

  final UserProfileErrorType type;
  final String message;

  @override
  List<Object?> get props => [type, message];
}
