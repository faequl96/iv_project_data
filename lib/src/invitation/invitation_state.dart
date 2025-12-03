part of 'invitation_cubit.dart';

class InvitationState extends Equatable {
  const InvitationState({
    this.isLoadingCreate = false,
    this.isLoadingGetById = false,
    this.isLoadingGets = false,
    this.isLoadingGetsByUserId = false,
    this.isLoadingUpdateById = false,
    this.isLoadingDeleteById = false,
    this.invitation,
    this.invitationById,
    this.invitations,
    this.invitationsByUserId,
    this.invitationsBySearch,
    this.error,
  });

  final bool isLoadingCreate;
  final bool isLoadingGetById;
  final bool isLoadingGets;
  final bool isLoadingGetsByUserId;
  final bool isLoadingUpdateById;
  final bool isLoadingDeleteById;
  final InvitationResponse? invitation;
  final InvitationResponse? invitationById;
  final List<InvitationResponse>? invitations;
  final List<InvitationResponse>? invitationsByUserId;
  final List<InvitationResponse>? invitationsBySearch;

  final InvitationError? error;

  InvitationState copyWith({
    bool? isLoadingCreate,
    bool? isLoadingGetById,
    bool? isLoadingGets,
    bool? isLoadingGetsByUserId,
    bool? isLoadingUpdateById,
    bool? isLoadingDeleteById,
    CopyWithValue<InvitationResponse?>? invitation,
    CopyWithValue<InvitationResponse?>? invitationById,
    CopyWithValue<List<InvitationResponse>?>? invitations,
    CopyWithValue<List<InvitationResponse>?>? invitationsByUserId,
    CopyWithValue<List<InvitationResponse>?>? invitationsBySearch,
    CopyWithValue<InvitationError?>? error,
  }) {
    return InvitationState(
      isLoadingCreate: isLoadingCreate ?? this.isLoadingCreate,
      isLoadingGetById: isLoadingGetById ?? this.isLoadingGetById,
      isLoadingGets: isLoadingGets ?? this.isLoadingGets,
      isLoadingGetsByUserId: isLoadingGetsByUserId ?? this.isLoadingGetsByUserId,
      isLoadingUpdateById: isLoadingUpdateById ?? this.isLoadingUpdateById,
      isLoadingDeleteById: isLoadingDeleteById ?? this.isLoadingDeleteById,
      invitation: invitation != null ? invitation.value : this.invitation,
      invitationById: invitationById != null ? invitationById.value : this.invitationById,
      invitations: invitations != null ? invitations.value : this.invitations,
      invitationsByUserId: invitationsByUserId != null ? invitationsByUserId.value : this.invitationsByUserId,
      invitationsBySearch: invitationsBySearch != null ? invitationsBySearch.value : this.invitationsBySearch,
      error: error != null ? error.value : this.error,
    );
  }

  void emitState() => GlobalContextService.value.read<InvitationCubit>().emitState(this);

  @override
  List<Object?> get props => [
    isLoadingCreate,
    isLoadingGetById,
    isLoadingGets,
    isLoadingGetsByUserId,
    isLoadingUpdateById,
    isLoadingDeleteById,
    invitation,
    invitationById,
    invitations,
    invitationsByUserId,
    invitationsBySearch,
    error,
  ];
}

enum InvitationErrorType { create, getById, gets, getsByUserId, getsBySearch, updateById, deleteById }

class InvitationError extends Equatable {
  const InvitationError.create(this.message) : type = InvitationErrorType.create;
  const InvitationError.getById(this.message) : type = InvitationErrorType.getById;
  const InvitationError.gets(this.message) : type = InvitationErrorType.gets;
  const InvitationError.getsByUserId(this.message) : type = InvitationErrorType.getsByUserId;
  const InvitationError.getsBySearch(this.message) : type = InvitationErrorType.getsBySearch;
  const InvitationError.updateById(this.message) : type = InvitationErrorType.updateById;
  const InvitationError.deleteById(this.message) : type = InvitationErrorType.deleteById;

  final InvitationErrorType type;
  final String message;

  @override
  List<Object?> get props => [type, message];
}
