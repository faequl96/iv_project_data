import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iv_project_api_core/iv_project_api_core.dart';
import 'package:iv_project_core/iv_project_core.dart';
import 'package:iv_project_model/iv_project_model.dart';
import 'package:iv_project_repository/iv_project_repository.dart';

part 'iv_coin_state.dart';

class IVCoinCubit extends Cubit<IVCoinState> {
  IVCoinCubit({required IVCoinRepository repository, required AdMobRepository adMobRepository})
    : _repository = repository,
      _adMobRepository = adMobRepository,
      super(const IVCoinState());

  final IVCoinRepository _repository;
  final AdMobRepository _adMobRepository;

  void emitState(IVCoinState state) => emit(state);

  Future<bool> get() async {
    try {
      emit(state.copyWith(isLoadingGet: true, error: null.toCopyWithValue()));
      final ivCoin = await _repository.get();
      emit(state.copyWith(isLoadingGet: false, ivCoin: ivCoin.toCopyWithValue()));

      return true;
    } catch (e) {
      final message = MessageService.getFromException(
        e is Exception ? e : Exception(AppLocalization.translate('common.error.thereIsAnError')),
      );
      emit(state.copyWith(isLoadingGet: false, error: IVCoinError.get(message).toCopyWithValue()));

      return false;
    }
  }

  Future<bool> addExtraIVCoins(AdMobRequest request) async {
    try {
      emit(state.copyWith(isLoadingUpdateByAddExtra: true, error: null.toCopyWithValue()));
      final ivCoin = await _adMobRepository.addExtraIVCoins(request);
      emit(state.copyWith(isLoadingUpdateByAddExtra: false, ivCoin: ivCoin.toCopyWithValue()));

      return true;
    } catch (e) {
      final message = MessageService.getFromException(
        e is Exception ? e : Exception(AppLocalization.translate('common.error.thereIsAnError')),
      );
      emit(state.copyWith(isLoadingUpdateByAddExtra: false, error: IVCoinError.updateByAddExtra(message).toCopyWithValue()));

      return false;
    }
  }
}
