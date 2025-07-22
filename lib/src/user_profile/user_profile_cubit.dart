import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iv_project_api_core/iv_project_api_core.dart';
import 'package:iv_project_core/iv_project_core.dart';
import 'package:iv_project_model/iv_project_model.dart';
import 'package:iv_project_repository/iv_project_repository.dart';

part 'user_profile_request.dart';
part 'user_profile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  UserProfileCubit({required UserProfileRepository repository}) : _repository = repository, super(const UserProfileState());

  final UserProfileRepository _repository;

  void emitState(UserProfileState state) => emit(state);

  Future<bool> get() async {
    try {
      emit(state.copyWith(isLoadingGet: true, error: null.toCopyWithValue()));
      final UserProfileResponse userProfile = await _repository.get();
      emit(state.copyWith(isLoadingGet: false, userProfile: userProfile.toCopyWithValue()));

      return true;
    } catch (e) {
      final message = MessageService.getFromException(
        e is Exception ? e : Exception(AppLocalization.translate('common.error.thereIsAnError')),
      );
      emit(state.copyWith(isLoadingGet: false, error: UserProfileError.get(message).toCopyWithValue()));

      return false;
    }
  }

  Future<bool> getById(int id) async {
    try {
      emit(state.copyWith(isLoadingGetById: true, error: null.toCopyWithValue()));
      final UserProfileResponse userProfile = await _repository.getById(id);
      emit(state.copyWith(isLoadingGetById: false, userProfileById: userProfile.toCopyWithValue()));

      return true;
    } catch (e) {
      final message = MessageService.getFromException(
        e is Exception ? e : Exception(AppLocalization.translate('common.error.thereIsAnError')),
      );
      emit(state.copyWith(isLoadingGetById: false, error: UserProfileError.getById(message).toCopyWithValue()));

      return false;
    }
  }

  Future<bool> update(UserProfileUpdateRequest request) async {
    try {
      emit(state.copyWith(isLoadingUpdate: true, error: null.toCopyWithValue()));
      final UserProfileResponse userProfile = await _repository.update(
        UserProfileRequest(firstName: request.firstName, lastName: request.lastName),
      );
      emit(state.copyWith(isLoadingUpdate: false, userProfile: userProfile.toCopyWithValue()));

      return true;
    } catch (e) {
      final message = MessageService.getFromException(
        e is Exception ? e : Exception(AppLocalization.translate('common.error.thereIsAnError')),
      );
      emit(state.copyWith(isLoadingUpdate: false, error: UserProfileError.update(message).toCopyWithValue()));

      return false;
    }
  }

  Future<bool> updateById(int id, UserProfileUpdateRequest request) async {
    try {
      emit(state.copyWith(isLoadingUpdateById: true, error: null.toCopyWithValue()));
      final UserProfileResponse userProfile = await _repository.updateById(
        id,
        UserProfileRequest(firstName: request.firstName, lastName: request.lastName),
      );
      emit(state.copyWith(isLoadingUpdateById: false, userProfileById: userProfile.toCopyWithValue()));

      return true;
    } catch (e) {
      final message = MessageService.getFromException(
        e is Exception ? e : Exception(AppLocalization.translate('common.error.thereIsAnError')),
      );
      emit(state.copyWith(isLoadingUpdateById: false, error: UserProfileError.updateById(message).toCopyWithValue()));

      return false;
    }
  }
}
