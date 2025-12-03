part of 'review_cubit.dart';

class ReviewState extends Equatable {
  const ReviewState({
    this.isLoadingCreate = false,
    this.isLoadingGetById = false,
    this.isLoadingGets = false,
    this.isLoadingUpdateById = false,
    this.isLoadingDeleteById = false,
    this.review,
    this.reviewById,
    this.reviews,
    this.error,
  });

  final bool isLoadingCreate;
  final bool isLoadingGetById;
  final bool isLoadingGets;
  final bool isLoadingUpdateById;
  final bool isLoadingDeleteById;
  final ReviewResponse? review;
  final ReviewResponse? reviewById;
  final List<ReviewResponse>? reviews;

  final ReviewError? error;

  ReviewState copyWith({
    bool? isLoadingCreate,
    bool? isLoadingGetById,
    bool? isLoadingGets,
    bool? isLoadingUpdateById,
    bool? isLoadingDeleteById,
    CopyWithValue<ReviewResponse?>? review,
    CopyWithValue<ReviewResponse?>? reviewById,
    CopyWithValue<List<ReviewResponse>?>? reviews,
    CopyWithValue<ReviewError?>? error,
  }) {
    return ReviewState(
      isLoadingCreate: isLoadingCreate ?? this.isLoadingCreate,
      isLoadingGetById: isLoadingGetById ?? this.isLoadingGetById,
      isLoadingGets: isLoadingGets ?? this.isLoadingGets,
      isLoadingUpdateById: isLoadingUpdateById ?? this.isLoadingUpdateById,
      isLoadingDeleteById: isLoadingDeleteById ?? this.isLoadingDeleteById,
      review: review != null ? review.value : this.review,
      reviewById: reviewById != null ? reviewById.value : this.reviewById,
      reviews: reviews != null ? reviews.value : this.reviews,
      error: error != null ? error.value : this.error,
    );
  }

  void emitState() => GlobalContextService.value.read<ReviewCubit>().emitState(this);

  @override
  List<Object?> get props => [
    isLoadingCreate,
    isLoadingGetById,
    isLoadingGets,
    isLoadingUpdateById,
    isLoadingDeleteById,
    review,
    reviewById,
    reviews,
    error,
  ];
}

enum ReviewErrorType { create, getById, gets, updateById, deleteById }

class ReviewError extends Equatable {
  const ReviewError.create(this.message) : type = ReviewErrorType.create;
  const ReviewError.getById(this.message) : type = ReviewErrorType.getById;
  const ReviewError.gets(this.message) : type = ReviewErrorType.gets;
  const ReviewError.updateById(this.message) : type = ReviewErrorType.updateById;
  const ReviewError.deleteById(this.message) : type = ReviewErrorType.deleteById;

  final ReviewErrorType type;
  final String message;

  @override
  List<Object?> get props => [type, message];
}
