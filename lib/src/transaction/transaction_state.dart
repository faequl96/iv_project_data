part of 'transaction_cubit.dart';

class TransactionState extends Equatable {
  const TransactionState({
    this.isLoadingCreate = false,
    this.isLoadingGetById = false,
    this.isLoadingGetByReferenceNumber = false,
    this.isLoadingGetsByUserIdByStatusFinished = false,
    this.isLoadingGetsByUserIdByStatusUnfinished = false,
    this.isLoadingUpdateById = false,
    this.isLoadingIssueById = false,
    this.isLoadingCheckById = false,
    this.isLoadingResetById = false,
    this.transaction,
    this.transactionsByUserIdByStatusFinished,
    this.transactionsByUserIdByStatusUnfinished,
    this.error,
  });

  final bool isLoadingCreate;
  final bool isLoadingGetById;
  final bool isLoadingGetByReferenceNumber;
  final bool isLoadingGetsByUserIdByStatusFinished;
  final bool isLoadingGetsByUserIdByStatusUnfinished;
  final bool isLoadingUpdateById;
  final bool isLoadingIssueById;
  final bool isLoadingCheckById;
  final bool isLoadingResetById;
  final TransactionResponse? transaction;
  final List<TransactionResponse>? transactionsByUserIdByStatusFinished;
  final List<TransactionResponse>? transactionsByUserIdByStatusUnfinished;

  final TransactionError? error;

  TransactionState copyWith({
    bool? isLoadingCreate,
    bool? isLoadingGetById,
    bool? isLoadingGetByReferenceNumber,
    bool? isLoadingGetsByUserIdByStatusFinished,
    bool? isLoadingGetsByUserIdByStatusUnfinished,
    bool? isLoadingUpdateById,
    bool? isLoadingIssueById,
    bool? isLoadingCheckById,
    bool? isLoadingResetById,
    CopyWithValue<TransactionResponse?>? transaction,
    CopyWithValue<List<TransactionResponse>?>? transactionsByUserIdByStatusFinished,
    CopyWithValue<List<TransactionResponse>?>? transactionsByUserIdByStatusUnfinished,
    CopyWithValue<TransactionError?>? error,
  }) {
    return TransactionState(
      isLoadingCreate: isLoadingCreate ?? this.isLoadingCreate,
      isLoadingGetById: isLoadingGetById ?? this.isLoadingGetById,
      isLoadingGetByReferenceNumber: isLoadingGetByReferenceNumber ?? this.isLoadingGetByReferenceNumber,
      isLoadingGetsByUserIdByStatusFinished: isLoadingGetsByUserIdByStatusFinished ?? this.isLoadingGetsByUserIdByStatusFinished,
      isLoadingGetsByUserIdByStatusUnfinished:
          isLoadingGetsByUserIdByStatusUnfinished ?? this.isLoadingGetsByUserIdByStatusUnfinished,
      isLoadingUpdateById: isLoadingUpdateById ?? this.isLoadingUpdateById,
      isLoadingIssueById: isLoadingIssueById ?? this.isLoadingIssueById,
      isLoadingCheckById: isLoadingCheckById ?? this.isLoadingCheckById,
      isLoadingResetById: isLoadingResetById ?? this.isLoadingResetById,
      transaction: transaction != null ? transaction.value : this.transaction,
      transactionsByUserIdByStatusFinished: transactionsByUserIdByStatusFinished != null
          ? transactionsByUserIdByStatusFinished.value
          : this.transactionsByUserIdByStatusFinished,
      transactionsByUserIdByStatusUnfinished: transactionsByUserIdByStatusUnfinished != null
          ? transactionsByUserIdByStatusUnfinished.value
          : this.transactionsByUserIdByStatusUnfinished,
      error: error != null ? error.value : this.error,
    );
  }

  void emitState() => GlobalContextService.value.read<TransactionCubit>().emitState(this);

  @override
  List<Object?> get props => [
    isLoadingCreate,
    isLoadingGetById,
    isLoadingGetByReferenceNumber,
    isLoadingGetsByUserIdByStatusFinished,
    isLoadingGetsByUserIdByStatusUnfinished,
    isLoadingUpdateById,
    isLoadingIssueById,
    isLoadingCheckById,
    isLoadingResetById,
    transaction,
    transactionsByUserIdByStatusFinished,
    transactionsByUserIdByStatusUnfinished,
    error,
  ];
}

enum TransactionErrorType {
  create,
  getById,
  getByReferenceNumber,
  getsByUserIdByStatusFinished,
  getsByUserIdByStatusUnfinished,
  updateById,
  issueById,
  checkById,
  resetById,
}

class TransactionError extends Equatable {
  const TransactionError.create(this.message) : type = TransactionErrorType.create;
  const TransactionError.getById(this.message) : type = TransactionErrorType.getById;
  const TransactionError.getByReferenceNumber(this.message) : type = TransactionErrorType.getByReferenceNumber;
  const TransactionError.getsByUserIdByStatusFinished(this.message) : type = TransactionErrorType.getsByUserIdByStatusFinished;
  const TransactionError.getsByUserIdByStatusUnfinished(this.message)
    : type = TransactionErrorType.getsByUserIdByStatusUnfinished;
  const TransactionError.updateById(this.message) : type = TransactionErrorType.updateById;
  const TransactionError.issueById(this.message) : type = TransactionErrorType.issueById;
  const TransactionError.checkById(this.message) : type = TransactionErrorType.checkById;
  const TransactionError.resetById(this.message) : type = TransactionErrorType.resetById;

  final TransactionErrorType type;
  final String message;

  @override
  List<Object?> get props => [type, message];
}
