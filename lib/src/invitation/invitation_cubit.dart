import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      emit(state.copyWith(isLoadingCreate: true, invitation: null.toCopyWithValue(), error: null.toCopyWithValue()));
      final invitation = await _repository.create(request, imageRequest);
      final newInvitationsByUserId = <InvitationResponse>[];

      newInvitationsByUserId.add(invitation);
      newInvitationsByUserId.addAll(state.invitationsByUserId ?? <InvitationResponse>[]);

      emit(
        state.copyWith(
          isLoadingCreate: false,
          invitation: invitation.toCopyWithValue(),
          invitationsByUserId: newInvitationsByUserId.toCopyWithValue(),
        ),
      );

      return true;
    } catch (e) {
      final message = e is String ? e : AppLocalization.translate('common.error.anErrorOccurred');
      emit(state.copyWith(isLoadingCreate: false, error: InvitationError.create(message).toCopyWithValue()));

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
      final invitations = await _repository.gets(
        query: QueryRequest(
          page: page,
          limit: limit,
          filterGroups: [
            FilterGroup(
              joinType: .and,
              filters: [Filter(field: 'user_id', operator: .equals, value: userId)],
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
      final message = e is String ? e : AppLocalization.translate('common.error.anErrorOccurred');
      emit(state.copyWith(isLoadingGetsByUserId: false, error: InvitationError.getsByUserId(message).toCopyWithValue()));

      return false;
    }
  }

  Future<bool> updateById(String id, UpdateInvitationRequest request, InvitationImageRequest? imageRequest) async {
    try {
      emit(state.copyWith(isLoadingUpdateById: true, error: null.toCopyWithValue()));
      final invitation = await _repository.updateById(id, request, imageRequest);
      final newInvitationsByUserId = <InvitationResponse>[];
      for (final item in state.invitationsByUserId ?? <InvitationResponse>[]) {
        if (item.id == invitation.id) newInvitationsByUserId.add(invitation);
        if (item.id == invitation.id) continue;
        newInvitationsByUserId.add(item);
      }
      emit(
        state.copyWith(
          isLoadingUpdateById: false,
          invitation: invitation.toCopyWithValue(),
          invitationsByUserId: newInvitationsByUserId.toCopyWithValue(),
        ),
      );

      return true;
    } catch (e) {
      final message = e is String ? e : AppLocalization.translate('common.error.anErrorOccurred');
      emit(state.copyWith(isLoadingUpdateById: false, error: InvitationError.updateById(message).toCopyWithValue()));

      return false;
    }
  }
}
