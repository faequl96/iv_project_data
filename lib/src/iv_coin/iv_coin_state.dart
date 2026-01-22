part of 'iv_coin_cubit.dart';

class IVCoinState extends Equatable {
  const IVCoinState({this.isLoadingGet = false, this.isLoadingUpdateByAddExtra = false, this.ivCoin, this.error});

  final bool isLoadingGet;
  final bool isLoadingUpdateByAddExtra;
  final IVCoinResponse? ivCoin;

  final IVCoinError? error;

  IVCoinState copyWith({
    bool? isLoadingGet,
    bool? isLoadingUpdateByAddExtra,
    CopyWithValue<IVCoinResponse?>? ivCoin,
    CopyWithValue<IVCoinError?>? error,
  }) {
    return IVCoinState(
      isLoadingGet: isLoadingGet ?? this.isLoadingGet,
      isLoadingUpdateByAddExtra: isLoadingUpdateByAddExtra ?? this.isLoadingUpdateByAddExtra,
      ivCoin: ivCoin != null ? ivCoin.value : this.ivCoin,
      error: error != null ? error.value : this.error,
    );
  }

  void emitState() => GlobalContextService.value.read<IVCoinCubit>().emitState(this);

  @override
  List<Object?> get props => [isLoadingGet, isLoadingUpdateByAddExtra, ivCoin, error];
}

enum IVCoinErrorType { get, updateByAddExtra }

class IVCoinError extends Equatable {
  const IVCoinError.get(this.message) : type = IVCoinErrorType.get;
  const IVCoinError.updateByAddExtra(this.message) : type = IVCoinErrorType.updateByAddExtra;

  final IVCoinErrorType type;
  final String message;

  @override
  List<Object?> get props => [type, message];
}
