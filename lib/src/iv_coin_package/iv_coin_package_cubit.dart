import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iv_project_api_core/iv_project_api_core.dart';
import 'package:iv_project_core/iv_project_core.dart';
import 'package:iv_project_model/iv_project_model.dart';
import 'package:iv_project_repository/iv_project_repository.dart';

part 'iv_coin_package_state.dart';

class IVCoinPackageCubit extends Cubit<IVCoinPackageState> {
  IVCoinPackageCubit({required IVCoinPackageRepository repository}) : _repository = repository, super(const IVCoinPackageState());

  final IVCoinPackageRepository _repository;

  void emitState(IVCoinPackageState state) => emit(state);

  Future<bool> create(CreateIVCoinPackageRequest request) async {
    try {
      emit(state.copyWith(isLoadingCreate: true, error: null.toCopyWithValue()));
      final IVCoinPackageResponse ivCoinPackage = await _repository.create(request);
      emit(state.copyWith(isLoadingCreate: false));

      emit(state.copyWith(isLoadingGets: true));
      final newIVCoinPackages = [ivCoinPackage, ...(state.ivCoinPackages ?? <IVCoinPackageResponse>[])];
      emit(state.copyWith(isLoadingGets: false, ivCoinPackages: newIVCoinPackages.toCopyWithValue()));

      return true;
    } catch (e) {
      final message = MessageService.getFromException(
        e is Exception ? e : Exception(AppLocalization.translate('common.error.thereIsAnError')),
      );
      emit(state.copyWith(isLoadingCreate: false, error: IVCoinPackageError.create(message).toCopyWithValue()));

      return false;
    }
  }

  Future<bool> getById(String id) async {
    try {
      emit(state.copyWith(isLoadingGetById: true, error: null.toCopyWithValue()));
      final IVCoinPackageResponse ivCoinPackage = await _repository.getById(id);
      emit(state.copyWith(isLoadingGetById: false, ivCoinPackageById: ivCoinPackage.toCopyWithValue()));

      return true;
    } catch (e) {
      final message = MessageService.getFromException(
        e is Exception ? e : Exception(AppLocalization.translate('common.error.thereIsAnError')),
      );
      emit(state.copyWith(isLoadingGetById: false, error: IVCoinPackageError.getById(message).toCopyWithValue()));

      return false;
    }
  }

  Future<bool> gets() async {
    try {
      emit(state.copyWith(isLoadingGets: true, error: null.toCopyWithValue()));
      final List<IVCoinPackageResponse> ivCoinPackages = await _repository.gets();
      emit(state.copyWith(isLoadingGets: false, ivCoinPackages: ivCoinPackages.toCopyWithValue()));

      return true;
    } catch (e) {
      final message = MessageService.getFromException(
        e is Exception ? e : Exception(AppLocalization.translate('common.error.thereIsAnError')),
      );
      emit(state.copyWith(isLoadingGets: false, error: IVCoinPackageError.gets(message).toCopyWithValue()));

      return false;
    }
  }

  Future<bool> updateById(String id, UpdateIVCoinPackageRequest request) async {
    try {
      emit(state.copyWith(isLoadingUpdateById: true, error: null.toCopyWithValue()));
      final IVCoinPackageResponse ivCoinPackage = await _repository.updateById(id, request);
      emit(state.copyWith(isLoadingUpdateById: false, ivCoinPackageById: ivCoinPackage.toCopyWithValue()));

      emit(state.copyWith(isLoadingGets: true));
      final newIVCoinPackages = <IVCoinPackageResponse>[];
      for (final item in state.ivCoinPackages ?? <IVCoinPackageResponse>[]) {
        if (item.id == ivCoinPackage.id) newIVCoinPackages.add(ivCoinPackage);
        if (item.id == ivCoinPackage.id) continue;
        newIVCoinPackages.add(item);
      }
      emit(state.copyWith(isLoadingGets: false, ivCoinPackages: newIVCoinPackages.toCopyWithValue()));

      return true;
    } catch (e) {
      final message = MessageService.getFromException(
        e is Exception ? e : Exception(AppLocalization.translate('common.error.thereIsAnError')),
      );
      emit(state.copyWith(isLoadingUpdateById: false, error: IVCoinPackageError.updateById(message).toCopyWithValue()));

      return false;
    }
  }

  Future<bool> deleteById(String id) async {
    try {
      emit(state.copyWith(isLoadingDeleteById: true, error: null.toCopyWithValue()));
      await _repository.deleteById(id);
      emit(state.copyWith(isLoadingDeleteById: false, ivCoinPackageById: null.toCopyWithValue()));

      await Future.delayed(const Duration(milliseconds: 200));
      emit(state.copyWith(isLoadingGets: true));
      final newIVCoinPackages = <IVCoinPackageResponse>[];
      for (final item in state.ivCoinPackages ?? <IVCoinPackageResponse>[]) {
        newIVCoinPackages.add(item);
      }
      newIVCoinPackages.removeWhere((item) => item.id == id);
      emit(state.copyWith(isLoadingGets: false, ivCoinPackages: newIVCoinPackages.toCopyWithValue()));

      return true;
    } catch (e) {
      final message = MessageService.getFromException(
        e is Exception ? e : Exception(AppLocalization.translate('common.error.thereIsAnError')),
      );
      emit(state.copyWith(isLoadingDeleteById: false, error: IVCoinPackageError.deleteById(message).toCopyWithValue()));

      return false;
    }
  }
}
