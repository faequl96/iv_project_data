import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iv_project_core/iv_project_core.dart';
import 'package:iv_project_model/iv_project_model.dart';
import 'package:iv_project_repository/iv_project_repository.dart';

part 'iv_coin_package_state.dart';

class IVCoinPackageCubit extends Cubit<IVCoinPackageState> {
  IVCoinPackageCubit({required IVCoinPackageRepository repository}) : _repository = repository, super(const IVCoinPackageState());

  final IVCoinPackageRepository _repository;

  void emitState(IVCoinPackageState state) => emit(state);

  Future<bool> gets() async {
    try {
      emit(state.copyWith(isLoadingGets: true, error: null.toCopyWithValue()));
      final ivCoinPackages = await _repository.gets();
      emit(state.copyWith(isLoadingGets: false, ivCoinPackages: ivCoinPackages.toCopyWithValue()));

      return true;
    } catch (e) {
      final message = e is String ? e : AppLocalization.translate('common.error.anErrorOccurred');
      emit(state.copyWith(isLoadingGets: false, error: IVCoinPackageError.gets(message).toCopyWithValue()));

      return false;
    }
  }
}
