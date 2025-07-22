part of 'discount_cubit.dart';

class DiscountState extends Equatable {
  const DiscountState({this.isLoadingIVCoinPackage = false, this.isLoadingInvitationTheme = false, this.discount, this.error});

  final bool isLoadingIVCoinPackage;
  final bool isLoadingInvitationTheme;
  final DiscountResponse? discount;

  final DiscountError? error;

  DiscountState copyWith({
    bool? isLoadingIVCoinPackage,
    bool? isLoadingInvitationTheme,
    CopyWithValue<DiscountResponse?>? discount,
    CopyWithValue<DiscountError?>? error,
  }) {
    return DiscountState(
      isLoadingIVCoinPackage: isLoadingIVCoinPackage ?? this.isLoadingIVCoinPackage,
      isLoadingInvitationTheme: isLoadingInvitationTheme ?? this.isLoadingInvitationTheme,
      discount: discount != null ? discount.value : this.discount,
      error: error != null ? error.value : this.error,
    );
  }

  void emitState() => GlobalContextService.value.read<DiscountCubit>().emitState(this);

  @override
  List<Object?> get props => [isLoadingIVCoinPackage, isLoadingInvitationTheme, discount, error];
}

class DiscountError extends Equatable {
  const DiscountError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
