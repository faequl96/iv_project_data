import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iv_project_api_core/iv_project_api_core.dart';
import 'package:iv_project_core/iv_project_core.dart';
import 'package:iv_project_model/iv_project_model.dart';
import 'package:iv_project_repository/iv_project_repository.dart';

part 'invitation_state.dart';

class InvitationCubit extends Cubit<InvitationState> {
  InvitationCubit({required InvitationRepository repository}) : _repository = repository, super(const InvitationState());

  final InvitationRepository _repository;

  void emitState(InvitationState state) => emit(state);

  Future<bool> create(CreateInvitationRequest request, InvitationImageRequest? imageRequest) async {
    try {
      emit(state.copyWith(isLoadingCreate: true, error: null.toCopyWithValue()));
      final InvitationResponse invitation = await _repository.create(request, imageRequest);
      emit(state.copyWith(isLoadingCreate: false, invitation: invitation.toCopyWithValue()));

      return true;
    } catch (e) {
      final message = MessageService.getFromException(
        e is Exception ? e : Exception(AppLocalization.translate('common.error.thereIsAnError')),
      );
      emit(state.copyWith(isLoadingCreate: false, error: InvitationError.create(message).toCopyWithValue()));

      return false;
    }
  }

  Future<bool> getById(String id) async {
    try {
      emit(state.copyWith(isLoadingGetById: true, error: null.toCopyWithValue()));
      final InvitationResponse invitation = await _repository.getById(id);
      emit(state.copyWith(isLoadingGetById: false, invitationById: invitation.toCopyWithValue()));

      return true;
    } catch (e) {
      final message = MessageService.getFromException(
        e is Exception ? e : Exception(AppLocalization.translate('common.error.thereIsAnError')),
      );
      emit(state.copyWith(isLoadingGetById: false, error: InvitationError.getById(message).toCopyWithValue()));

      return false;
    }
  }

  Future<bool> gets({QueryRequest? query}) async {
    try {
      emit(state.copyWith(isLoadingGets: true, error: null.toCopyWithValue()));
      final List<InvitationResponse> invitations = await _repository.gets(query: query);
      emit(state.copyWith(isLoadingGets: false, invitations: invitations.toCopyWithValue()));

      return true;
    } catch (e) {
      final message = MessageService.getFromException(
        e is Exception ? e : Exception(AppLocalization.translate('common.error.thereIsAnError')),
      );
      emit(state.copyWith(isLoadingGets: false, error: InvitationError.gets(message).toCopyWithValue()));

      return false;
    }
  }

  Future<bool> getsByUserId(String userId, {required int page, required int limit, void Function()? infiniteScrollMax}) async {
    try {
      emit(
        state.copyWith(
          isLoadingGetsByUserId: true,
          invitationsByUserId: page == 1 ? null.toCopyWithValue() : state.invitationsByUserId.toCopyWithValue(),
          error: null.toCopyWithValue(),
        ),
      );
      final List<InvitationResponse> invitations = await _repository.gets(
        query: QueryRequest(
          page: page,
          limit: limit,
          filterGroups: [
            FilterGroup(
              joinType: JoinType.and,
              filters: [Filter(field: 'user_id', operator: OperatorType.equals, value: userId)],
            ),
          ],
        ),
      );
      if (invitations.length < limit) infiniteScrollMax?.call();

      List<InvitationResponse> newInvitations = [];
      if (page == 1) {
        newInvitations = invitations;
      } else {
        newInvitations = [...(state.invitationsByUserId ?? []), ...invitations];
      }
      emit(state.copyWith(isLoadingGetsByUserId: false, invitationsByUserId: newInvitations.toCopyWithValue()));

      return true;
    } catch (e) {
      final message = MessageService.getFromException(
        e is Exception ? e : Exception(AppLocalization.translate('common.error.thereIsAnError')),
      );
      emit(state.copyWith(isLoadingGetsByUserId: false, error: InvitationError.gets(message).toCopyWithValue()));

      return false;
    }
  }

  Future<bool> updateById(String id, UpdateInvitationRequest request, InvitationImageRequest? imageRequest) async {
    try {
      emit(state.copyWith(isLoadingUpdateById: true, error: null.toCopyWithValue()));
      final InvitationResponse invitation = await _repository.updateById(id, request, imageRequest);
      final newInvitationsByUserId = <InvitationResponse>[];
      for (final item in state.invitations ?? <InvitationResponse>[]) {
        if (item.id == invitation.id) newInvitationsByUserId.add(invitation);
        if (item.id == invitation.id) continue;
        newInvitationsByUserId.add(item);
      }
      emit(
        state.copyWith(
          isLoadingUpdateById: false,
          invitationById: invitation.toCopyWithValue(),
          invitationsByUserId: newInvitationsByUserId.toCopyWithValue(),
        ),
      );

      return true;
    } catch (e) {
      final message = MessageService.getFromException(
        e is Exception ? e : Exception(AppLocalization.translate('common.error.thereIsAnError')),
      );
      emit(state.copyWith(isLoadingUpdateById: false, error: InvitationError.updateById(message).toCopyWithValue()));

      return false;
    }
  }

  Future<bool> deleteById(String id) async {
    try {
      emit(state.copyWith(isLoadingDeleteById: true, error: null.toCopyWithValue()));
      await _repository.deleteById(id);
      final newInvitations = <InvitationResponse>[];
      for (final item in state.invitations ?? <InvitationResponse>[]) {
        newInvitations.add(item);
      }
      newInvitations.removeWhere((item) => item.id == id);
      emit(state.copyWith(isLoadingDeleteById: false, invitationById: null, invitations: newInvitations.toCopyWithValue()));

      return true;
    } catch (e) {
      final message = MessageService.getFromException(
        e is Exception ? e : Exception(AppLocalization.translate('common.error.thereIsAnError')),
      );
      emit(state.copyWith(isLoadingDeleteById: false, error: InvitationError.deleteById(message).toCopyWithValue()));

      return false;
    }
  }
}
