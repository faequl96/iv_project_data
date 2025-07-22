import 'package:equatable/equatable.dart';

class AdMobUpdateRequest extends Equatable {
  const AdMobUpdateRequest({required this.amount});

  final int amount;

  @override
  List<Object?> get props => [amount];
}
