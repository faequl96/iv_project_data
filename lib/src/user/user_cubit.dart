import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iv_project_api_core/iv_project_api_core.dart';
import 'package:iv_project_core/iv_project_core.dart';
import 'package:iv_project_model/iv_project_model.dart';
import 'package:iv_project_repository/iv_project_repository.dart';

part 'user_request.dart';
part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit({required UserRepository repository}) : _repository = repository, super(const UserState());

  final UserRepository _repository;

  void emitState(UserState state) => emit(state);

  Future<bool> get() async {
    try {
      emit(state.copyWith(isLoadingGet: true, error: null.toCopyWithValue()));
      final UserResponse user = await _repository.get();
      emit(state.copyWith(isLoadingGet: false, user: user.toCopyWithValue()));

      return true;
    } catch (e) {
      final message = MessageService.getFromException(
        e is Exception ? e : Exception(AppLocalization.translate('common.error.thereIsAnError')),
      );
      emit(state.copyWith(isLoadingGet: false, error: UserError.get(message).toCopyWithValue()));

      return false;
    }
  }

  Future<bool> getById(String id) async {
    try {
      emit(state.copyWith(isLoadingGetById: true, error: null.toCopyWithValue()));
      final UserResponse user = await _repository.getById(id);
      emit(state.copyWith(isLoadingGetById: false, userById: user.toCopyWithValue()));

      return true;
    } catch (e) {
      final message = MessageService.getFromException(
        e is Exception ? e : Exception(AppLocalization.translate('common.error.thereIsAnError')),
      );
      emit(state.copyWith(isLoadingGetById: false, error: UserError.getById(message).toCopyWithValue()));

      return false;
    }
  }

  Future<bool> gets({QueryRequest? query}) async {
    try {
      emit(state.copyWith(isLoadingGets: true, error: null.toCopyWithValue()));
      final List<UserResponse> users = await _repository.gets(query: query);
      if (query == null) emit(state.copyWith(isLoadingGets: false, users: users.toCopyWithValue()));
      if (query != null) emit(state.copyWith(isLoadingGets: false, usersBySearch: users.toCopyWithValue()));

      return true;
    } catch (e) {
      final message = MessageService.getFromException(
        e is Exception ? e : Exception(AppLocalization.translate('common.error.thereIsAnError')),
      );
      emit(state.copyWith(isLoadingGets: false, error: UserError.gets(message).toCopyWithValue()));

      return false;
    }
  }

  Future<bool> updateById(String id, UserUpdateRequest request) async {
    try {
      emit(state.copyWith(isLoadingUpdateById: true, error: null.toCopyWithValue()));
      final UserResponse user = await _repository.updateById(id, UserRequest(role: request.role));
      final newUsers = <UserResponse>[];
      for (final item in state.users ?? <UserResponse>[]) {
        if (item.id == user.id) newUsers.add(user);
        if (item.id == user.id) continue;
        newUsers.add(item);
      }
      emit(state.copyWith(isLoadingUpdateById: false, userById: user.toCopyWithValue(), users: newUsers.toCopyWithValue()));

      return true;
    } catch (e) {
      final message = MessageService.getFromException(
        e is Exception ? e : Exception(AppLocalization.translate('common.error.thereIsAnError')),
      );
      emit(state.copyWith(isLoadingUpdateById: false, error: UserError.updateById(message).toCopyWithValue()));

      return false;
    }
  }

  Future<bool> delete() async {
    try {
      emit(state.copyWith(isLoadingDelete: true, error: null.toCopyWithValue()));
      await _repository.delete();
      emit(state.copyWith(isLoadingDelete: false, user: null));

      NavigationService.go(RoutePath.loginPage);

      return true;
    } catch (e) {
      final message = MessageService.getFromException(
        e is Exception ? e : Exception(AppLocalization.translate('common.error.thereIsAnError')),
      );
      emit(state.copyWith(isLoadingDelete: false, error: UserError.delete(message).toCopyWithValue()));

      return false;
    }
  }

  Future<bool> deleteById(String id) async {
    try {
      emit(state.copyWith(isLoadingDeleteById: true, error: null.toCopyWithValue()));
      await _repository.deleteById(id);
      final newUsers = <UserResponse>[];
      for (final item in state.users ?? <UserResponse>[]) {
        newUsers.add(item);
      }
      newUsers.removeWhere((item) => item.id == id);
      emit(state.copyWith(isLoadingDeleteById: false, userById: null, users: newUsers.toCopyWithValue()));

      return true;
    } catch (e) {
      final message = MessageService.getFromException(
        e is Exception ? e : Exception(AppLocalization.translate('common.error.thereIsAnError')),
      );
      emit(state.copyWith(isLoadingDeleteById: false, error: UserError.deleteById(message).toCopyWithValue()));

      return false;
    }
  }
}
