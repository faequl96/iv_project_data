part of 'invitation_cubit.dart';

class InvitationState extends Equatable {
  const InvitationState({
    this.isLoadingCreate = false,
    this.isLoadingGetsByUserId = false,
    this.isLoadingUpdateById = false,
    this.invitation,
    this.invitationsByUserId,
    this.error,
  });

  final bool isLoadingCreate;
  final bool isLoadingGetsByUserId;
  final bool isLoadingUpdateById;
  final InvitationResponse? invitation;
  final List<InvitationResponse>? invitationsByUserId;

  final InvitationError? error;

  InvitationState copyWith({
    bool? isLoadingCreate,
    bool? isLoadingGetsByUserId,
    bool? isLoadingUpdateById,
    CopyWithValue<InvitationResponse?>? invitation,
    CopyWithValue<List<InvitationResponse>?>? invitationsByUserId,
    CopyWithValue<InvitationError?>? error,
  }) {
    return InvitationState(
      isLoadingCreate: isLoadingCreate ?? this.isLoadingCreate,
      isLoadingGetsByUserId: isLoadingGetsByUserId ?? this.isLoadingGetsByUserId,
      isLoadingUpdateById: isLoadingUpdateById ?? this.isLoadingUpdateById,
      invitation: invitation != null ? invitation.value : this.invitation,
      invitationsByUserId: invitationsByUserId != null ? invitationsByUserId.value : this.invitationsByUserId,
      error: error != null ? error.value : this.error,
    );
  }

  void emitState() => GlobalContextService.value.read<InvitationCubit>().emitState(this);

  @override
  List<Object?> get props => [
    isLoadingCreate,
    isLoadingGetsByUserId,
    isLoadingUpdateById,
    invitation,
    invitationsByUserId,
    error,
  ];
}

enum InvitationErrorType { create, getsByUserId, updateById }

class InvitationError extends Equatable {
  const InvitationError.create(this.message) : type = InvitationErrorType.create;
  const InvitationError.getsByUserId(this.message) : type = InvitationErrorType.getsByUserId;
  const InvitationError.updateById(this.message) : type = InvitationErrorType.updateById;

  final InvitationErrorType type;
  final String message;

  @override
  List<Object?> get props => [type, message];
}
