part of 'invitation_theme_cubit.dart';

class InvitationThemeState extends Equatable {
  const InvitationThemeState({
    this.isLoadingCreate = false,
    this.isLoadingGetById = false,
    this.isLoadingGets = false,
    this.isLoadingUpdateById = false,
    this.isLoadingDeleteById = false,
    this.invitationThemeById,
    this.invitationThemes,
    this.error,
  });

  final bool isLoadingCreate;
  final bool isLoadingGetById;
  final bool isLoadingGets;
  final bool isLoadingUpdateById;
  final bool isLoadingDeleteById;
  final InvitationThemeResponse? invitationThemeById;
  final List<InvitationThemeResponse>? invitationThemes;

  final InvitationThemeError? error;

  InvitationThemeState copyWith({
    bool? isLoadingCreate,
    bool? isLoadingGetById,
    bool? isLoadingGets,
    bool? isLoadingUpdateById,
    bool? isLoadingDeleteById,
    CopyWithValue<InvitationThemeResponse?>? invitationThemeById,
    CopyWithValue<List<InvitationThemeResponse>?>? invitationThemes,
    CopyWithValue<InvitationThemeError?>? error,
  }) {
    return InvitationThemeState(
      isLoadingCreate: isLoadingCreate ?? this.isLoadingCreate,
      isLoadingGetById: isLoadingGetById ?? this.isLoadingGetById,
      isLoadingGets: isLoadingGets ?? this.isLoadingGets,
      isLoadingUpdateById: isLoadingUpdateById ?? this.isLoadingUpdateById,
      isLoadingDeleteById: isLoadingDeleteById ?? this.isLoadingDeleteById,
      invitationThemeById: invitationThemeById != null ? invitationThemeById.value : this.invitationThemeById,
      invitationThemes: invitationThemes != null ? invitationThemes.value : this.invitationThemes,
      error: error != null ? error.value : this.error,
    );
  }

  void emitState() => GlobalContextService.value.read<InvitationThemeCubit>().emitState(this);

  @override
  List<Object?> get props => [
    isLoadingCreate,
    isLoadingGetById,
    isLoadingGets,
    isLoadingUpdateById,
    isLoadingDeleteById,
    invitationThemeById,
    invitationThemes,
    error,
  ];
}

enum InvitationThemeErrorType { create, getById, gets, updateById, deleteById }

class InvitationThemeError extends Equatable {
  const InvitationThemeError.create(this.message) : type = InvitationThemeErrorType.create;
  const InvitationThemeError.getById(this.message) : type = InvitationThemeErrorType.getById;
  const InvitationThemeError.gets(this.message) : type = InvitationThemeErrorType.gets;
  const InvitationThemeError.updateById(this.message) : type = InvitationThemeErrorType.updateById;
  const InvitationThemeError.deleteById(this.message) : type = InvitationThemeErrorType.deleteById;

  final InvitationThemeErrorType type;
  final String message;

  @override
  List<Object?> get props => [type, message];
}
