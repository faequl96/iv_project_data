part of 'transaction_cubit.dart';

class TransactionCreateRequest extends Equatable {
  const TransactionCreateRequest({required this.productType, required this.productId, required this.userId});

  final ProductType productType;
  final int productId;
  final String userId;

  @override
  List<Object?> get props => [productType, productId, userId];
}

class TransactionUpdateRequest extends Equatable {
  const TransactionUpdateRequest({this.paymentMethod, this.voucherCodeName});

  final String? paymentMethod;
  final String? voucherCodeName;

  @override
  List<Object?> get props => [paymentMethod, voucherCodeName];
}
