import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iv_project_api_core/iv_project_api_core.dart';
import 'package:iv_project_core/iv_project_core.dart';
import 'package:iv_project_model/iv_project_model.dart';
import 'package:iv_project_repository/iv_project_repository.dart';

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
}
