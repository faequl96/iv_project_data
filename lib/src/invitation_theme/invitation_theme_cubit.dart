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

  Future<bool> create(CreateInvitationThemeRequest request) async {
    try {
      emit(state.copyWith(isLoadingCreate: true, error: null.toCopyWithValue()));
      final InvitationThemeResponse invitationTheme = await _repository.create(request);
      emit(state.copyWith(isLoadingCreate: false));

      emit(state.copyWith(isLoadingGets: true));
      final newInvitationThemes = [invitationTheme, ...(state.invitationThemes ?? <InvitationThemeResponse>[])];
      emit(state.copyWith(isLoadingGets: false, invitationThemes: newInvitationThemes.toCopyWithValue()));

      return true;
    } catch (e) {
      final message = MessageService.getFromException(
        e is Exception ? e : Exception(AppLocalization.translate('common.error.thereIsAnError')),
      );
      emit(state.copyWith(isLoadingCreate: false, error: InvitationThemeError.create(message).toCopyWithValue()));

      return false;
    }
  }

  Future<bool> getById(int id) async {
    try {
      emit(state.copyWith(isLoadingGetById: true, error: null.toCopyWithValue()));
      final InvitationThemeResponse invitationTheme = await _repository.getById(id);
      emit(state.copyWith(isLoadingGetById: false, invitationThemeById: invitationTheme.toCopyWithValue()));

      return true;
    } catch (e) {
      final message = MessageService.getFromException(
        e is Exception ? e : Exception(AppLocalization.translate('common.error.thereIsAnError')),
      );
      emit(state.copyWith(isLoadingGetById: false, error: InvitationThemeError.getById(message).toCopyWithValue()));

      return false;
    }
  }

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

  Future<bool> updateById(int id, UpdateInvitationThemeRequest request) async {
    try {
      emit(state.copyWith(isLoadingUpdateById: true, error: null.toCopyWithValue()));
      final InvitationThemeResponse invitationTheme = await _repository.updateById(id, request);
      emit(state.copyWith(isLoadingUpdateById: false, invitationThemeById: invitationTheme.toCopyWithValue()));

      emit(state.copyWith(isLoadingGets: true));
      final newInvitationThemes = <InvitationThemeResponse>[];
      for (final item in state.invitationThemes ?? <InvitationThemeResponse>[]) {
        if (item.id == invitationTheme.id) newInvitationThemes.add(invitationTheme);
        if (item.id == invitationTheme.id) continue;
        newInvitationThemes.add(item);
      }
      emit(state.copyWith(isLoadingGets: false, invitationThemes: newInvitationThemes.toCopyWithValue()));

      return true;
    } catch (e) {
      final message = MessageService.getFromException(
        e is Exception ? e : Exception(AppLocalization.translate('common.error.thereIsAnError')),
      );
      emit(state.copyWith(isLoadingUpdateById: false, error: InvitationThemeError.updateById(message).toCopyWithValue()));

      return false;
    }
  }

  Future<bool> deleteById(int id) async {
    try {
      emit(state.copyWith(isLoadingDeleteById: true, error: null.toCopyWithValue()));
      await _repository.deleteById(id);
      emit(state.copyWith(isLoadingDeleteById: false, invitationThemeById: null.toCopyWithValue()));

      await Future.delayed(const Duration(milliseconds: 200));
      emit(state.copyWith(isLoadingGets: true));
      final newInvitationThemes = <InvitationThemeResponse>[];
      for (final item in state.invitationThemes ?? <InvitationThemeResponse>[]) {
        newInvitationThemes.add(item);
      }
      newInvitationThemes.removeWhere((item) => item.id == id);
      emit(state.copyWith(isLoadingGets: false, invitationThemes: newInvitationThemes.toCopyWithValue()));

      return true;
    } catch (e) {
      final message = MessageService.getFromException(
        e is Exception ? e : Exception(AppLocalization.translate('common.error.thereIsAnError')),
      );
      emit(state.copyWith(isLoadingDeleteById: false, error: InvitationThemeError.deleteById(message).toCopyWithValue()));

      return false;
    }
  }
}
