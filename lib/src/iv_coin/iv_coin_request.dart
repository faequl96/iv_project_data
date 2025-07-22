part of 'iv_coin_cubit.dart';

class IVCoinUpdateRequest extends Equatable {
  const IVCoinUpdateRequest({required this.balance});

  final int balance;

  @override
  List<Object?> get props => [balance];
}
