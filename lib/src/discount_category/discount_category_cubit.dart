import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iv_project_api_core/iv_project_api_core.dart';
import 'package:iv_project_core/iv_project_core.dart';
import 'package:iv_project_model/iv_project_model.dart';
import 'package:iv_project_repository/iv_project_repository.dart';

part 'discount_category_request.dart';
part 'discount_category_state.dart';

class DiscountCategoryCubit extends Cubit<DiscountCategoryState> {
  DiscountCategoryCubit({required DiscountCategoryRepository repository})
    : _repository = repository,
      super(const DiscountCategoryState());

  final DiscountCategoryRepository _repository;

  void emitState(DiscountCategoryState state) => emit(state);

  Future<bool> create(DiscountCategoryCreateRequest request) async {
    try {
      emit(state.copyWith(isLoadingCreate: true, error: null.toCopyWithValue()));
      final DiscountCategoryResponse discountCategory = await _repository.create(DiscountCategoryRequest(name: request.name));
      final newDiscountCategories = [discountCategory, ...(state.discountCategories ?? <DiscountCategoryResponse>[])];
      emit(state.copyWith(isLoadingCreate: false, discountCategories: newDiscountCategories.toCopyWithValue()));

      return true;
    } catch (e) {
      final message = MessageService.getFromException(
        e is Exception ? e : Exception(AppLocalization.translate('common.error.thereIsAnError')),
      );
      emit(state.copyWith(isLoadingCreate: false, error: DiscountCategoryError.create(message).toCopyWithValue()));

      return false;
    }
  }

  Future<bool> getById(int id) async {
    try {
      emit(state.copyWith(isLoadingGetById: true, error: null.toCopyWithValue()));
      final DiscountCategoryResponse discountCategory = await _repository.getById(id);
      emit(state.copyWith(isLoadingGetById: false, discountCategoryById: discountCategory.toCopyWithValue()));

      return true;
    } catch (e) {
      final message = MessageService.getFromException(
        e is Exception ? e : Exception(AppLocalization.translate('common.error.thereIsAnError')),
      );
      emit(state.copyWith(isLoadingGetById: false, error: DiscountCategoryError.getById(message).toCopyWithValue()));

      return false;
    }
  }

  Future<bool> gets() async {
    try {
      emit(state.copyWith(isLoadingGets: true, error: null.toCopyWithValue()));
      final List<DiscountCategoryResponse> discountCategories = await _repository.gets();
      emit(state.copyWith(isLoadingGets: false, discountCategories: discountCategories.toCopyWithValue()));

      return true;
    } catch (e) {
      final message = MessageService.getFromException(
        e is Exception ? e : Exception(AppLocalization.translate('common.error.thereIsAnError')),
      );
      emit(state.copyWith(isLoadingGets: false, error: DiscountCategoryError.gets(message).toCopyWithValue()));

      return false;
    }
  }

  Future<bool> updateById(int id, DiscountCategoryUpdateRequest request) async {
    try {
      emit(state.copyWith(isLoadingUpdateById: true, error: null.toCopyWithValue()));
      final DiscountCategoryResponse discountCategory = await _repository.updateById(
        id,
        DiscountCategoryRequest(name: request.name),
      );
      final newDiscountCategories = <DiscountCategoryResponse>[];
      for (final item in state.discountCategories ?? <DiscountCategoryResponse>[]) {
        if (item.id == discountCategory.id) newDiscountCategories.add(discountCategory);
        if (item.id == discountCategory.id) continue;
        newDiscountCategories.add(item);
      }
      emit(
        state.copyWith(
          isLoadingUpdateById: false,
          discountCategoryById: discountCategory.toCopyWithValue(),
          discountCategories: newDiscountCategories.toCopyWithValue(),
        ),
      );

      return true;
    } catch (e) {
      final message = MessageService.getFromException(
        e is Exception ? e : Exception(AppLocalization.translate('common.error.thereIsAnError')),
      );
      emit(state.copyWith(isLoadingUpdateById: false, error: DiscountCategoryError.updateById(message).toCopyWithValue()));

      return false;
    }
  }

  Future<bool> deleteById(int id) async {
    try {
      emit(state.copyWith(isLoadingDeleteById: true, error: null.toCopyWithValue()));
      await _repository.deleteById(id);
      final newDiscountCategories = <DiscountCategoryResponse>[];
      for (final item in state.discountCategories ?? <DiscountCategoryResponse>[]) {
        newDiscountCategories.add(item);
      }
      newDiscountCategories.removeWhere((item) => item.id == id);
      emit(
        state.copyWith(
          isLoadingDeleteById: false,
          discountCategoryById: null,
          discountCategories: newDiscountCategories.toCopyWithValue(),
        ),
      );

      return true;
    } catch (e) {
      final message = MessageService.getFromException(
        e is Exception ? e : Exception(AppLocalization.translate('common.error.thereIsAnError')),
      );
      emit(state.copyWith(isLoadingDeleteById: false, error: DiscountCategoryError.deleteById(message).toCopyWithValue()));

      return false;
    }
  }
}
