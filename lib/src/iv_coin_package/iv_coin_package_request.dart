part of 'iv_coin_package_cubit.dart';

class IVCoinPackageCreateRequest extends Equatable {
  const IVCoinPackageCreateRequest({
    required this.name,
    required this.coinAmount,
    required this.idrPrice,
    required this.discountCategoryIds,
  });

  final String name;
  final int coinAmount;
  final int idrPrice;
  final List<int> discountCategoryIds;

  @override
  List<Object?> get props => [name, coinAmount, idrPrice, discountCategoryIds];
}

class IVCoinPackageUpdateRequest extends Equatable {
  const IVCoinPackageUpdateRequest({this.name, this.coinAmount, this.idrPrice, this.discountCategoryIds});

  final String? name;
  final int? coinAmount;
  final int? idrPrice;
  final List<int>? discountCategoryIds;

  @override
  List<Object?> get props => [name, coinAmount, idrPrice, discountCategoryIds];
}
