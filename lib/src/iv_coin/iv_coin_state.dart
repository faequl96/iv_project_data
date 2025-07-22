part of 'iv_coin_cubit.dart';

class IVCoinState extends Equatable {
  const IVCoinState({
    this.isLoadingGet = false,
    this.isLoadingGetById = false,
    this.isLoadingUpdateById = false,
    this.isLoadingUpdateByAddExtra = false,
    this.ivCoin,
    this.ivCoinById,
    this.error,
  });

  final bool isLoadingGet;
  final bool isLoadingGetById;
  final bool isLoadingUpdateById;
  final bool isLoadingUpdateByAddExtra;
  final IVCoinResponse? ivCoin;
  final IVCoinResponse? ivCoinById;

  final IVCoinError? error;

  IVCoinState copyWith({
    bool? isLoadingGet,
    bool? isLoadingGetById,
    bool? isLoadingUpdateById,
    bool? isLoadingUpdateByAddExtra,
    CopyWithValue<IVCoinResponse?>? ivCoin,
    CopyWithValue<IVCoinResponse?>? ivCoinById,
    CopyWithValue<IVCoinError?>? error,
  }) {
    return IVCoinState(
      isLoadingGet: isLoadingGet ?? this.isLoadingGet,
      isLoadingGetById: isLoadingGetById ?? this.isLoadingGetById,
      isLoadingUpdateById: isLoadingUpdateById ?? this.isLoadingUpdateById,
      isLoadingUpdateByAddExtra: isLoadingUpdateByAddExtra ?? this.isLoadingUpdateByAddExtra,
      ivCoin: ivCoin != null ? ivCoin.value : this.ivCoin,
      ivCoinById: ivCoinById != null ? ivCoinById.value : this.ivCoinById,
      error: error != null ? error.value : this.error,
    );
  }

  void emitState() => GlobalContextService.value.read<IVCoinCubit>().emitState(this);

  @override
  List<Object?> get props => [
    isLoadingGet,
    isLoadingGetById,
    isLoadingUpdateById,
    isLoadingUpdateByAddExtra,
    ivCoin,
    ivCoinById,
    error,
  ];
}

enum IVCoinErrorType { get, getById, updateById, updateByAddExtra }

class IVCoinError extends Equatable {
  const IVCoinError.get(this.message) : type = IVCoinErrorType.get;
  const IVCoinError.getById(this.message) : type = IVCoinErrorType.getById;
  const IVCoinError.updateById(this.message) : type = IVCoinErrorType.updateById;
  const IVCoinError.updateByAddExtra(this.message) : type = IVCoinErrorType.updateByAddExtra;

  final IVCoinErrorType type;
  final String message;

  @override
  List<Object?> get props => [type, message];
}
