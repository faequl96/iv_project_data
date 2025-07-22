import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iv_project_api_core/iv_project_api_core.dart';
import 'package:iv_project_core/iv_project_core.dart';
import 'package:iv_project_model/iv_project_model.dart';
import 'package:iv_project_repository/iv_project_repository.dart';

part 'discount_request.dart';
part 'discount_state.dart';

class DiscountCubit extends Cubit<DiscountState> {
  DiscountCubit({required DiscountRepository repository}) : _repository = repository, super(const DiscountState());

  final DiscountRepository _repository;

  void emitState(DiscountState state) => emit(state);

  Future<bool> setProductPrices(DiscountUpdateRequest request) async {
    try {
      emit(state.copyWith(isLoadingIVCoinPackage: true, isLoadingInvitationTheme: true, error: null.toCopyWithValue()));
      final DiscountResponse discount = await _repository.setProductPrices(
        DiscountRequest(discountCategoryId: request.discountCategoryId, percentage: request.percentage),
      );
      emit(state.copyWith(isLoadingIVCoinPackage: false, isLoadingInvitationTheme: false, discount: discount.toCopyWithValue()));

      return true;
    } catch (e) {
      final message = MessageService.getFromException(
        e is Exception ? e : Exception(AppLocalization.translate('common.error.thereIsAnError')),
      );
      emit(
        state.copyWith(
          isLoadingIVCoinPackage: false,
          isLoadingInvitationTheme: false,
          error: DiscountError(message).toCopyWithValue(),
        ),
      );

      return false;
    }
  }
}
