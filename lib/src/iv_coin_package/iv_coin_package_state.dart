part of 'iv_coin_package_cubit.dart';

class IVCoinPackageState extends Equatable {
  const IVCoinPackageState({this.isLoadingGets = false, this.ivCoinPackages, this.error});

  final bool isLoadingGets;
  final List<IVCoinPackageResponse>? ivCoinPackages;

  final IVCoinPackageError? error;

  IVCoinPackageState copyWith({
    bool? isLoadingGets,
    CopyWithValue<List<IVCoinPackageResponse>?>? ivCoinPackages,
    CopyWithValue<IVCoinPackageError?>? error,
  }) {
    return IVCoinPackageState(
      isLoadingGets: isLoadingGets ?? this.isLoadingGets,
      ivCoinPackages: ivCoinPackages != null ? ivCoinPackages.value : this.ivCoinPackages,
      error: error != null ? error.value : this.error,
    );
  }

  void emitState() => GlobalContextService.value.read<IVCoinPackageCubit>().emitState(this);

  @override
  List<Object?> get props => [isLoadingGets, ivCoinPackages, error];
}

enum IVCoinPackageErrorType { gets }

class IVCoinPackageError extends Equatable {
  const IVCoinPackageError.gets(this.message) : type = .gets;

  final IVCoinPackageErrorType type;
  final String message;

  @override
  List<Object?> get props => [type, message];
}
