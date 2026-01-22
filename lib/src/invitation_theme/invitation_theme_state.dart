part of 'invitation_theme_cubit.dart';

class InvitationThemeState extends Equatable {
  const InvitationThemeState({this.isLoadingGets = false, this.invitationThemes, this.error});

  final bool isLoadingGets;
  final List<InvitationThemeResponse>? invitationThemes;

  final InvitationThemeError? error;

  InvitationThemeState copyWith({
    bool? isLoadingGets,
    CopyWithValue<List<InvitationThemeResponse>?>? invitationThemes,
    CopyWithValue<InvitationThemeError?>? error,
  }) {
    return InvitationThemeState(
      isLoadingGets: isLoadingGets ?? this.isLoadingGets,
      invitationThemes: invitationThemes != null ? invitationThemes.value : this.invitationThemes,
      error: error != null ? error.value : this.error,
    );
  }

  void emitState() => GlobalContextService.value.read<InvitationThemeCubit>().emitState(this);

  @override
  List<Object?> get props => [isLoadingGets, invitationThemes, error];
}

enum InvitationThemeErrorType { gets }

class InvitationThemeError extends Equatable {
  const InvitationThemeError.gets(this.message) : type = InvitationThemeErrorType.gets;

  final InvitationThemeErrorType type;
  final String message;

  @override
  List<Object?> get props => [type, message];
}
