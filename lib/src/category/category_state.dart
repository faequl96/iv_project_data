part of 'category_cubit.dart';

class CategoryState extends Equatable {
  const CategoryState({
    this.isLoadingCreate = false,
    this.isLoadingGetById = false,
    this.isLoadingGets = false,
    this.isLoadingUpdateById = false,
    this.isLoadingDeleteById = false,
    this.categoryById,
    this.categories,
    this.error,
  });

  final bool isLoadingCreate;
  final bool isLoadingGetById;
  final bool isLoadingGets;
  final bool isLoadingUpdateById;
  final bool isLoadingDeleteById;
  final CategoryResponse? categoryById;
  final List<CategoryResponse>? categories;

  final CategoryError? error;

  CategoryState copyWith({
    bool? isLoadingCreate,
    bool? isLoadingGetById,
    bool? isLoadingGets,
    bool? isLoadingUpdateById,
    bool? isLoadingDeleteById,
    CopyWithValue<CategoryResponse?>? categoryById,
    CopyWithValue<List<CategoryResponse>?>? categories,
    CopyWithValue<CategoryError?>? error,
  }) {
    return CategoryState(
      isLoadingCreate: isLoadingCreate ?? this.isLoadingCreate,
      isLoadingGetById: isLoadingGetById ?? this.isLoadingGetById,
      isLoadingGets: isLoadingGets ?? this.isLoadingGets,
      isLoadingUpdateById: isLoadingUpdateById ?? this.isLoadingUpdateById,
      isLoadingDeleteById: isLoadingDeleteById ?? this.isLoadingDeleteById,
      categoryById: categoryById != null ? categoryById.value : this.categoryById,
      categories: categories != null ? categories.value : this.categories,
      error: error != null ? error.value : this.error,
    );
  }

  void emitState() => GlobalContextService.value.read<CategoryCubit>().emitState(this);

  @override
  List<Object?> get props => [
    isLoadingCreate,
    isLoadingGetById,
    isLoadingGets,
    isLoadingUpdateById,
    isLoadingDeleteById,
    categoryById,
    categories,
    error,
  ];
}

enum CategoryErrorType { create, getById, gets, updateById, deleteById }

class CategoryError extends Equatable {
  const CategoryError.create(this.message) : type = CategoryErrorType.create;
  const CategoryError.getById(this.message) : type = CategoryErrorType.getById;
  const CategoryError.gets(this.message) : type = CategoryErrorType.gets;
  const CategoryError.updateById(this.message) : type = CategoryErrorType.updateById;
  const CategoryError.deleteById(this.message) : type = CategoryErrorType.deleteById;

  final CategoryErrorType type;
  final String message;

  @override
  List<Object?> get props => [type, message];
}
