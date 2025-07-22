part of 'iv_coin_package_cubit.dart';

class IVCoinPackageState extends Equatable {
  const IVCoinPackageState({
    this.isLoadingCreate = false,
    this.isLoadingGetById = false,
    this.isLoadingGets = false,
    this.isLoadingUpdateById = false,
    this.isLoadingDeleteById = false,
    this.ivCoinPackageById,
    this.ivCoinPackages,
    this.error,
  });

  final bool isLoadingCreate;
  final bool isLoadingGetById;
  final bool isLoadingGets;
  final bool isLoadingUpdateById;
  final bool isLoadingDeleteById;
  final IVCoinPackageResponse? ivCoinPackageById;
  final List<IVCoinPackageResponse>? ivCoinPackages;

  final IVCoinPackageError? error;

  IVCoinPackageState copyWith({
    bool? isLoadingCreate,
    bool? isLoadingGetById,
    bool? isLoadingGets,
    bool? isLoadingUpdateById,
    bool? isLoadingDeleteById,
    CopyWithValue<IVCoinPackageResponse?>? ivCoinPackageById,
    CopyWithValue<List<IVCoinPackageResponse>?>? ivCoinPackages,
    CopyWithValue<IVCoinPackageError?>? error,
  }) {
    return IVCoinPackageState(
      isLoadingCreate: isLoadingCreate ?? this.isLoadingCreate,
      isLoadingGetById: isLoadingGetById ?? this.isLoadingGetById,
      isLoadingGets: isLoadingGets ?? this.isLoadingGets,
      isLoadingUpdateById: isLoadingUpdateById ?? this.isLoadingUpdateById,
      isLoadingDeleteById: isLoadingDeleteById ?? this.isLoadingDeleteById,
      ivCoinPackageById: ivCoinPackageById != null ? ivCoinPackageById.value : this.ivCoinPackageById,
      ivCoinPackages: ivCoinPackages != null ? ivCoinPackages.value : this.ivCoinPackages,
      error: error != null ? error.value : this.error,
    );
  }

  void emitState() => GlobalContextService.value.read<IVCoinPackageCubit>().emitState(this);

  @override
  List<Object?> get props => [
    isLoadingCreate,
    isLoadingGetById,
    isLoadingGets,
    isLoadingUpdateById,
    isLoadingDeleteById,
    ivCoinPackageById,
    ivCoinPackages,
    error,
  ];
}

enum IVCoinPackageErrorType { create, getById, gets, updateById, deleteById }

class IVCoinPackageError extends Equatable {
  const IVCoinPackageError.create(this.message) : type = IVCoinPackageErrorType.create;
  const IVCoinPackageError.getById(this.message) : type = IVCoinPackageErrorType.getById;
  const IVCoinPackageError.gets(this.message) : type = IVCoinPackageErrorType.gets;
  const IVCoinPackageError.updateById(this.message) : type = IVCoinPackageErrorType.updateById;
  const IVCoinPackageError.deleteById(this.message) : type = IVCoinPackageErrorType.deleteById;

  final IVCoinPackageErrorType type;
  final String message;

  @override
  List<Object?> get props => [type, message];
}
