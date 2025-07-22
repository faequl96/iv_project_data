part of 'invitation_theme_cubit.dart';

class InvitationThemeCreateRequest extends Equatable {
  const InvitationThemeCreateRequest({
    required this.name,
    required this.idrPrice,
    required this.ivcPrice,
    required this.categoryIds,
    required this.discountCategoryIds,
  });

  final String name;
  final int idrPrice;
  final int ivcPrice;
  final List<int> categoryIds;
  final List<int> discountCategoryIds;

  @override
  List<Object?> get props => [name, idrPrice, ivcPrice, categoryIds, discountCategoryIds];
}

class InvitationThemeUpdateRequest extends Equatable {
  const InvitationThemeUpdateRequest({this.name, this.idrPrice, this.ivcPrice, this.categoryIds, this.discountCategoryIds});

  final String? name;
  final int? idrPrice;
  final int? ivcPrice;
  final List<int>? categoryIds;
  final List<int>? discountCategoryIds;

  @override
  List<Object?> get props => [name, idrPrice, ivcPrice, categoryIds, discountCategoryIds];
}
