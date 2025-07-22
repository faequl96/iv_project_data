part of 'discount_category_cubit.dart';

class DiscountCategoryState extends Equatable {
  const DiscountCategoryState({
    this.isLoadingCreate = false,
    this.isLoadingGetById = false,
    this.isLoadingGets = false,
    this.isLoadingUpdateById = false,
    this.isLoadingDeleteById = false,
    this.discountCategoryById,
    this.discountCategories,
    this.error,
  });

  final bool isLoadingCreate;
  final bool isLoadingGetById;
  final bool isLoadingGets;
  final bool isLoadingUpdateById;
  final bool isLoadingDeleteById;
  final DiscountCategoryResponse? discountCategoryById;
  final List<DiscountCategoryResponse>? discountCategories;

  final DiscountCategoryError? error;

  DiscountCategoryState copyWith({
    bool? isLoadingCreate,
    bool? isLoadingGetById,
    bool? isLoadingGets,
    bool? isLoadingUpdateById,
    bool? isLoadingDeleteById,
    CopyWithValue<DiscountCategoryResponse?>? discountCategoryById,
    CopyWithValue<List<DiscountCategoryResponse>?>? discountCategories,
    CopyWithValue<DiscountCategoryError?>? error,
  }) {
    return DiscountCategoryState(
      isLoadingCreate: isLoadingCreate ?? this.isLoadingCreate,
      isLoadingGetById: isLoadingGetById ?? this.isLoadingGetById,
      isLoadingGets: isLoadingGets ?? this.isLoadingGets,
      isLoadingUpdateById: isLoadingUpdateById ?? this.isLoadingUpdateById,
      isLoadingDeleteById: isLoadingDeleteById ?? this.isLoadingDeleteById,
      discountCategoryById: discountCategoryById != null ? discountCategoryById.value : this.discountCategoryById,
      discountCategories: discountCategories != null ? discountCategories.value : this.discountCategories,
      error: error != null ? error.value : this.error,
    );
  }

  void emitState() => GlobalContextService.value.read<DiscountCategoryCubit>().emitState(this);

  @override
  List<Object?> get props => [
    isLoadingCreate,
    isLoadingGetById,
    isLoadingGets,
    isLoadingUpdateById,
    isLoadingDeleteById,
    discountCategoryById,
    discountCategories,
    error,
  ];
}

enum DiscountCategoryErrorType { create, getById, gets, updateById, deleteById }

class DiscountCategoryError extends Equatable {
  const DiscountCategoryError.create(this.message) : type = DiscountCategoryErrorType.create;
  const DiscountCategoryError.getById(this.message) : type = DiscountCategoryErrorType.getById;
  const DiscountCategoryError.gets(this.message) : type = DiscountCategoryErrorType.gets;
  const DiscountCategoryError.updateById(this.message) : type = DiscountCategoryErrorType.updateById;
  const DiscountCategoryError.deleteById(this.message) : type = DiscountCategoryErrorType.deleteById;

  final DiscountCategoryErrorType type;
  final String message;

  @override
  List<Object?> get props => [type, message];
}
