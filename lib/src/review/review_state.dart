part of 'review_cubit.dart';

class ReviewState extends Equatable {
  const ReviewState({this.isLoadingCreate = false, this.isLoadingUpdateById = false, this.review, this.error});

  final bool isLoadingCreate;
  final bool isLoadingUpdateById;
  final ReviewResponse? review;

  final ReviewError? error;

  ReviewState copyWith({
    bool? isLoadingCreate,
    bool? isLoadingUpdateById,
    CopyWithValue<ReviewResponse?>? review,
    CopyWithValue<ReviewError?>? error,
  }) {
    return ReviewState(
      isLoadingCreate: isLoadingCreate ?? this.isLoadingCreate,
      isLoadingUpdateById: isLoadingUpdateById ?? this.isLoadingUpdateById,
      review: review != null ? review.value : this.review,
      error: error != null ? error.value : this.error,
    );
  }

  void emitState() => GlobalContextService.value.read<ReviewCubit>().emitState(this);

  @override
  List<Object?> get props => [isLoadingCreate, isLoadingUpdateById, review, error];
}

enum ReviewErrorType { create, updateById }

class ReviewError extends Equatable {
  const ReviewError.create(this.message) : type = ReviewErrorType.create;
  const ReviewError.updateById(this.message) : type = ReviewErrorType.updateById;

  final ReviewErrorType type;
  final String message;

  @override
  List<Object?> get props => [type, message];
}
