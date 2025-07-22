part of 'discount_cubit.dart';

class DiscountUpdateRequest extends Equatable {
  const DiscountUpdateRequest({required this.discountCategoryId, required this.percentage});

  final int discountCategoryId;
  final int percentage;

  @override
  List<Object?> get props => [discountCategoryId, percentage];
}
