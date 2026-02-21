import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iv_project_core/iv_project_core.dart';
import 'package:iv_project_model/iv_project_model.dart';
import 'package:iv_project_repository/iv_project_repository.dart';

part 'review_state.dart';

class ReviewCubit extends Cubit<ReviewState> {
  ReviewCubit({required ReviewRepository repository}) : _repository = repository, super(const ReviewState());

  final ReviewRepository _repository;

  void emitState(ReviewState state) => emit(state);

  Future<bool> create(CreateReviewRequest request) async {
    try {
      emit(state.copyWith(isLoadingCreate: true, review: null.toCopyWithValue(), error: null.toCopyWithValue()));
      final review = await _repository.create(request);
      emit(state.copyWith(isLoadingCreate: false, review: review.toCopyWithValue()));

      return true;
    } catch (e) {
      final message = e is String ? e : AppLocalization.translate('common.error.anErrorOccurred');
      emit(state.copyWith(isLoadingCreate: false, error: ReviewError.create(message).toCopyWithValue()));

      return false;
    }
  }

  Future<bool> updateById(int id, UpdateReviewRequest request) async {
    try {
      emit(state.copyWith(isLoadingUpdateById: true, review: null.toCopyWithValue(), error: null.toCopyWithValue()));
      final review = await _repository.updateById(id, request);
      emit(state.copyWith(isLoadingUpdateById: false, review: review.toCopyWithValue()));

      return true;
    } catch (e) {
      final message = e is String ? e : AppLocalization.translate('common.error.anErrorOccurred');
      emit(state.copyWith(isLoadingUpdateById: false, error: ReviewError.updateById(message).toCopyWithValue()));

      return false;
    }
  }
}
