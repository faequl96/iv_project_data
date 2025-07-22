part of 'discount_category_cubit.dart';

class DiscountCategoryCreateRequest extends Equatable {
  const DiscountCategoryCreateRequest({required this.name});

  final String name;

  @override
  List<Object?> get props => [name];
}

class DiscountCategoryUpdateRequest extends Equatable {
  const DiscountCategoryUpdateRequest({required this.name});

  final String name;

  @override
  List<Object?> get props => [name];
}
