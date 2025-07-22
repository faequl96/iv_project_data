import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iv_project_api_core/iv_project_api_core.dart';
import 'package:iv_project_core/iv_project_core.dart';
import 'package:iv_project_model/iv_project_model.dart';
import 'package:iv_project_repository/iv_project_repository.dart';

part 'category_request.dart';
part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit({required CategoryRepository repository}) : _repository = repository, super(const CategoryState());

  final CategoryRepository _repository;

  void emitState(CategoryState state) => emit(state);

  Future<bool> create(CategoryCreateRequest request) async {
    try {
      emit(state.copyWith(isLoadingCreate: true, error: null.toCopyWithValue()));
      final CategoryResponse category = await _repository.create(CategoryRequest(name: request.name));
      final newCategories = [category, ...(state.categories ?? <CategoryResponse>[])];
      emit(state.copyWith(isLoadingCreate: false, categories: newCategories.toCopyWithValue()));

      return true;
    } catch (e) {
      final message = MessageService.getFromException(
        e is Exception ? e : Exception(AppLocalization.translate('common.error.thereIsAnError')),
      );
      emit(state.copyWith(isLoadingCreate: false, error: CategoryError.create(message).toCopyWithValue()));

      return false;
    }
  }

  Future<bool> getById(int id) async {
    try {
      emit(state.copyWith(isLoadingGetById: true, error: null.toCopyWithValue()));
      final CategoryResponse category = await _repository.getById(id);
      emit(state.copyWith(isLoadingGetById: false, categoryById: category.toCopyWithValue()));

      return true;
    } catch (e) {
      final message = MessageService.getFromException(
        e is Exception ? e : Exception(AppLocalization.translate('common.error.thereIsAnError')),
      );

      emit(state.copyWith(isLoadingGetById: false, error: CategoryError.getById(message).toCopyWithValue()));

      DialogService.showGeneralResponseStateError(message);

      return false;
    }
  }

  Future<bool> gets() async {
    try {
      emit(state.copyWith(isLoadingGets: true, error: null.toCopyWithValue()));
      final List<CategoryResponse> categories = await _repository.gets();
      emit(state.copyWith(isLoadingGets: false, categories: categories.toCopyWithValue()));

      return true;
    } catch (e) {
      final message = MessageService.getFromException(
        e is Exception ? e : Exception(AppLocalization.translate('common.error.thereIsAnError')),
      );
      emit(state.copyWith(isLoadingGets: false, error: CategoryError.gets(message).toCopyWithValue()));

      return false;
    }
  }

  Future<bool> updateById(int id, CategoryUpdateRequest request) async {
    try {
      emit(state.copyWith(isLoadingUpdateById: true, error: null.toCopyWithValue()));
      final CategoryResponse category = await _repository.updateById(id, CategoryRequest(name: request.name));
      final newCategories = <CategoryResponse>[];
      for (final item in state.categories ?? <CategoryResponse>[]) {
        if (item.id == category.id) newCategories.add(category);
        if (item.id == category.id) continue;
        newCategories.add(item);
      }
      emit(
        state.copyWith(
          isLoadingUpdateById: false,
          categoryById: category.toCopyWithValue(),
          categories: newCategories.toCopyWithValue(),
        ),
      );

      return true;
    } catch (e) {
      final message = MessageService.getFromException(
        e is Exception ? e : Exception(AppLocalization.translate('common.error.thereIsAnError')),
      );
      emit(state.copyWith(isLoadingUpdateById: false, error: CategoryError.updateById(message).toCopyWithValue()));

      return false;
    }
  }

  Future<bool> deleteById(int id) async {
    try {
      emit(state.copyWith(isLoadingDeleteById: true, error: null.toCopyWithValue()));
      await _repository.deleteById(id);
      final newCategories = <CategoryResponse>[];
      for (final item in state.categories ?? <CategoryResponse>[]) {
        newCategories.add(item);
      }
      newCategories.removeWhere((item) => item.id == id);
      emit(state.copyWith(isLoadingDeleteById: false, categoryById: null, categories: newCategories.toCopyWithValue()));

      return true;
    } catch (e) {
      final message = MessageService.getFromException(
        e is Exception ? e : Exception(AppLocalization.translate('common.error.thereIsAnError')),
      );
      emit(state.copyWith(isLoadingDeleteById: false, error: CategoryError.deleteById(message).toCopyWithValue()));

      return false;
    }
  }
}
