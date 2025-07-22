part of 'voucher_code_cubit.dart';

class VoucherCodeCreateRequest extends Equatable {
  const VoucherCodeCreateRequest({
    required this.name,
    required this.discountPercentage,
    required this.usageLimitPerUser,
    required this.isGlobal,
    this.userIds = const [],
  });

  final String name;
  final int discountPercentage;
  final int usageLimitPerUser;
  final bool isGlobal;
  final List<String> userIds;

  @override
  List<Object?> get props => [name, discountPercentage, usageLimitPerUser, isGlobal, userIds];
}

class VoucherCodeUpdateRequest extends Equatable {
  const VoucherCodeUpdateRequest({
    required this.name,
    required this.discountPercentage,
    required this.usageLimitPerUser,
    required this.isGlobal,
    this.userIds = const [],
  });

  final String name;
  final int discountPercentage;
  final int usageLimitPerUser;
  final bool isGlobal;
  final List<String> userIds;

  @override
  List<Object?> get props => [name, discountPercentage, usageLimitPerUser, isGlobal, userIds];
}
