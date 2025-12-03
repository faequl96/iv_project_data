import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iv_project_api_core/iv_project_api_core.dart';
import 'package:iv_project_core/iv_project_core.dart';
import 'package:iv_project_model/iv_project_model.dart';
import 'package:iv_project_repository/iv_project_repository.dart';

part 'voucher_code_state.dart';

class VoucherCodeCubit extends Cubit<VoucherCodeState> {
  VoucherCodeCubit({required VoucherCodeRepository repository}) : _repository = repository, super(const VoucherCodeState());

  final VoucherCodeRepository _repository;

  void emitState(VoucherCodeState state) => emit(state);

  Future<bool> create(VoucherCodeRequest request) async {
    try {
      emit(state.copyWith(isLoadingCreate: true, error: null.toCopyWithValue()));
      final VoucherCodeResponse voucherCode = await _repository.create(request);
      emit(state.copyWith(isLoadingCreate: false));

      emit(state.copyWith(isLoadingGets: true));
      final newVoucherCodes = [voucherCode, ...(state.voucherCodes ?? <VoucherCodeResponse>[])];
      emit(state.copyWith(isLoadingGets: false, voucherCodes: newVoucherCodes.toCopyWithValue()));

      return true;
    } catch (e) {
      final message = MessageService.getFromException(
        e is Exception ? e : Exception(AppLocalization.translate('common.error.thereIsAnError')),
      );
      emit(state.copyWith(isLoadingCreate: false, error: VoucherCodeError.create(message).toCopyWithValue()));

      return false;
    }
  }

  Future<bool> getById(int id) async {
    try {
      emit(state.copyWith(isLoadingGetById: true, error: null.toCopyWithValue()));
      final VoucherCodeResponse voucherCode = await _repository.getById(id);
      emit(state.copyWith(isLoadingGetById: false, voucherCodeById: voucherCode.toCopyWithValue()));

      return true;
    } catch (e) {
      final message = MessageService.getFromException(
        e is Exception ? e : Exception(AppLocalization.translate('common.error.thereIsAnError')),
      );
      emit(state.copyWith(isLoadingGetById: false, error: VoucherCodeError.getById(message).toCopyWithValue()));

      return false;
    }
  }

  Future<bool> gets() async {
    try {
      emit(state.copyWith(isLoadingGets: true, error: null.toCopyWithValue()));
      final List<VoucherCodeResponse> voucherCodes = await _repository.gets();
      emit(state.copyWith(isLoadingGets: false, voucherCodes: voucherCodes.toCopyWithValue()));

      return true;
    } catch (e) {
      final message = MessageService.getFromException(
        e is Exception ? e : Exception(AppLocalization.translate('common.error.thereIsAnError')),
      );
      emit(state.copyWith(isLoadingGets: false, error: VoucherCodeError.gets(message).toCopyWithValue()));

      return false;
    }
  }

  Future<bool> updateById(int id, VoucherCodeRequest request) async {
    try {
      emit(state.copyWith(isLoadingUpdateById: true, error: null.toCopyWithValue()));
      final VoucherCodeResponse voucherCode = await _repository.updateById(id, request);
      emit(state.copyWith(isLoadingUpdateById: false, voucherCodeById: voucherCode.toCopyWithValue()));

      emit(state.copyWith(isLoadingGets: true));
      final newVoucherCodes = <VoucherCodeResponse>[];
      for (final item in state.voucherCodes ?? <VoucherCodeResponse>[]) {
        if (item.id == voucherCode.id) newVoucherCodes.add(voucherCode);
        if (item.id == voucherCode.id) continue;
        newVoucherCodes.add(item);
      }
      emit(state.copyWith(isLoadingGets: false, voucherCodes: newVoucherCodes.toCopyWithValue()));

      return true;
    } catch (e) {
      final message = MessageService.getFromException(
        e is Exception ? e : Exception(AppLocalization.translate('common.error.thereIsAnError')),
      );
      emit(state.copyWith(isLoadingUpdateById: false, error: VoucherCodeError.updateById(message).toCopyWithValue()));

      return false;
    }
  }

  Future<bool> deleteById(int id) async {
    try {
      emit(state.copyWith(isLoadingDeleteById: true, error: null.toCopyWithValue()));
      await _repository.deleteById(id);
      emit(state.copyWith(isLoadingDeleteById: false, voucherCodeById: null.toCopyWithValue()));

      await Future.delayed(const Duration(milliseconds: 200));
      emit(state.copyWith(isLoadingGets: true));
      final newVoucherCodes = <VoucherCodeResponse>[];
      for (final item in state.voucherCodes ?? <VoucherCodeResponse>[]) {
        newVoucherCodes.add(item);
      }
      newVoucherCodes.removeWhere((item) => item.id == id);
      emit(state.copyWith(isLoadingGets: false, voucherCodes: newVoucherCodes.toCopyWithValue()));

      return true;
    } catch (e) {
      final message = MessageService.getFromException(
        e is Exception ? e : Exception(AppLocalization.translate('common.error.thereIsAnError')),
      );
      emit(state.copyWith(isLoadingDeleteById: false, error: VoucherCodeError.deleteById(message).toCopyWithValue()));

      return false;
    }
  }
}
