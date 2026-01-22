import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iv_project_api_core/iv_project_api_core.dart';
import 'package:iv_project_core/iv_project_core.dart';
import 'package:iv_project_model/iv_project_model.dart';
import 'package:iv_project_repository/iv_project_repository.dart';

part 'invitation_theme_state.dart';

class InvitationThemeCubit extends Cubit<InvitationThemeState> {
  InvitationThemeCubit({required InvitationThemeRepository repository})
    : _repository = repository,
      super(const InvitationThemeState());

  final InvitationThemeRepository _repository;

  void emitState(InvitationThemeState state) => emit(state);

  Future<bool> gets({QueryRequest? query}) async {
    try {
      emit(state.copyWith(isLoadingGets: true, error: null.toCopyWithValue()));
      final List<InvitationThemeResponse> invitationThemes = await _repository.gets(query: query);
      emit(state.copyWith(isLoadingGets: false, invitationThemes: invitationThemes.toCopyWithValue()));

      return true;
    } catch (e) {
      final message = MessageService.getFromException(
        e is Exception ? e : Exception(AppLocalization.translate('common.error.thereIsAnError')),
      );
      emit(state.copyWith(isLoadingGets: false, error: InvitationThemeError.gets(message).toCopyWithValue()));

      return false;
    }
  }
}
