part of 'category_cubit.dart';

class CategoryCreateRequest extends Equatable {
  const CategoryCreateRequest({required this.name});

  final String name;

  @override
  List<Object?> get props => [name];
}

class CategoryUpdateRequest extends Equatable {
  const CategoryUpdateRequest({required this.name});

  final String name;

  @override
  List<Object?> get props => [name];
}
