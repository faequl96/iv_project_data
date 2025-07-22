part of 'transaction_cubit.dart';

class TransactionState extends Equatable {
  const TransactionState({
    this.isLoadingCreate = false,
    this.isLoadingGetById = false,
    this.isLoadingGetByReferenceNumber = false,
    this.isLoadingGets = false,
    this.isLoadingGetsByUserId = false,
    this.isLoadingGetsByUserIdByStatusFinished = false,
    this.isLoadingGetsByUserIdByStatusUnfinished = false,
    this.isLoadingUpdateById = false,
    this.isLoadingDeleteById = false,
    this.isLoadingIssueById = false,
    this.isLoadingCheckById = false,
    this.isLoadingResetById = false,
    this.isLoadingConfirmationByManualByAdminById = false,
    this.transactionById,
    this.transactions,
    this.transactionsBySearch,
    this.transactionsByUserId,
    this.transactionsByUserIdByStatusFinished,
    this.transactionsByUserIdByStatusUnfinished,
    this.error,
  });

  final bool isLoadingCreate;
  final bool isLoadingGetById;
  final bool isLoadingGetByReferenceNumber;
  final bool isLoadingGets;
  final bool isLoadingGetsByUserId;
  final bool isLoadingGetsByUserIdByStatusFinished;
  final bool isLoadingGetsByUserIdByStatusUnfinished;
  final bool isLoadingUpdateById;
  final bool isLoadingDeleteById;
  final bool isLoadingIssueById;
  final bool isLoadingCheckById;
  final bool isLoadingResetById;
  final bool isLoadingConfirmationByManualByAdminById;
  final TransactionResponse? transactionById;
  final List<TransactionResponse>? transactions;
  final List<TransactionResponse>? transactionsBySearch;
  final List<TransactionResponse>? transactionsByUserId;
  final List<TransactionResponse>? transactionsByUserIdByStatusFinished;
  final List<TransactionResponse>? transactionsByUserIdByStatusUnfinished;

  final TransactionError? error;

  TransactionState copyWith({
    bool? isLoadingCreate,
    bool? isLoadingGetById,
    bool? isLoadingGetByReferenceNumber,
    bool? isLoadingGets,
    bool? isLoadingGetsByUserId,
    bool? isLoadingGetsByUserIdByStatusFinished,
    bool? isLoadingGetsByUserIdByStatusUnfinished,
    bool? isLoadingUpdateById,
    bool? isLoadingDeleteById,
    bool? isLoadingIssueById,
    bool? isLoadingCheckById,
    bool? isLoadingResetById,
    bool? isLoadingConfirmationByManualByAdminById,
    CopyWithValue<TransactionResponse?>? transactionById,
    CopyWithValue<List<TransactionResponse>?>? transactions,
    CopyWithValue<List<TransactionResponse>?>? transactionsBySearch,
    CopyWithValue<List<TransactionResponse>?>? transactionsByUserId,
    CopyWithValue<List<TransactionResponse>?>? transactionsByUserIdByStatusFinished,
    CopyWithValue<List<TransactionResponse>?>? transactionsByUserIdByStatusUnfinished,
    CopyWithValue<TransactionError?>? error,
  }) {
    return TransactionState(
      isLoadingCreate: isLoadingCreate ?? this.isLoadingCreate,
      isLoadingGetById: isLoadingGetById ?? this.isLoadingGetById,
      isLoadingGetByReferenceNumber: isLoadingGetByReferenceNumber ?? this.isLoadingGetByReferenceNumber,
      isLoadingGets: isLoadingGets ?? this.isLoadingGets,
      isLoadingGetsByUserId: isLoadingGetsByUserId ?? this.isLoadingGetsByUserId,
      isLoadingGetsByUserIdByStatusFinished: isLoadingGetsByUserIdByStatusFinished ?? this.isLoadingGetsByUserIdByStatusFinished,
      isLoadingGetsByUserIdByStatusUnfinished:
          isLoadingGetsByUserIdByStatusUnfinished ?? this.isLoadingGetsByUserIdByStatusUnfinished,
      isLoadingUpdateById: isLoadingUpdateById ?? this.isLoadingUpdateById,
      isLoadingDeleteById: isLoadingDeleteById ?? this.isLoadingDeleteById,
      isLoadingIssueById: isLoadingIssueById ?? this.isLoadingIssueById,
      isLoadingCheckById: isLoadingCheckById ?? this.isLoadingCheckById,
      isLoadingResetById: isLoadingResetById ?? this.isLoadingResetById,
      isLoadingConfirmationByManualByAdminById:
          isLoadingConfirmationByManualByAdminById ?? this.isLoadingConfirmationByManualByAdminById,
      transactionById: transactionById != null ? transactionById.value : this.transactionById,
      transactions: transactions != null ? transactions.value : this.transactions,
      transactionsBySearch: transactionsBySearch != null ? transactionsBySearch.value : this.transactionsBySearch,
      transactionsByUserId: transactionsByUserId != null ? transactionsByUserId.value : this.transactionsByUserId,
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
    isLoadingGets,
    isLoadingGetsByUserId,
    isLoadingGetsByUserIdByStatusFinished,
    isLoadingGetsByUserIdByStatusUnfinished,
    isLoadingUpdateById,
    isLoadingDeleteById,
    isLoadingIssueById,
    isLoadingCheckById,
    isLoadingResetById,
    isLoadingConfirmationByManualByAdminById,
    transactionById,
    transactions,
    transactionsBySearch,
    transactionsByUserId,
    transactionsByUserIdByStatusFinished,
    transactionsByUserIdByStatusUnfinished,
    error,
  ];
}

enum TransactionErrorType {
  create,
  getById,
  getByReferenceNumber,
  gets,
  getsByUserId,
  getsByUserIdByStatusFinished,
  getsByUserIdByStatusUnfinished,
  updateById,
  deleteById,
  issueById,
  checkById,
  resetById,
  confirmationByManualByAdminById,
}

class TransactionError extends Equatable {
  const TransactionError.create(this.message) : type = TransactionErrorType.create;
  const TransactionError.getById(this.message) : type = TransactionErrorType.getById;
  const TransactionError.getByReferenceNumber(this.message) : type = TransactionErrorType.getByReferenceNumber;
  const TransactionError.gets(this.message) : type = TransactionErrorType.gets;
  const TransactionError.getsByUserId(this.message) : type = TransactionErrorType.getsByUserId;
  const TransactionError.getsByUserIdByStatusFinished(this.message) : type = TransactionErrorType.getsByUserIdByStatusFinished;
  const TransactionError.getsByUserIdByStatusUnfinished(this.message)
    : type = TransactionErrorType.getsByUserIdByStatusUnfinished;
  const TransactionError.updateById(this.message) : type = TransactionErrorType.updateById;
  const TransactionError.deleteById(this.message) : type = TransactionErrorType.deleteById;
  const TransactionError.issueById(this.message) : type = TransactionErrorType.issueById;
  const TransactionError.checkById(this.message) : type = TransactionErrorType.checkById;
  const TransactionError.resetById(this.message) : type = TransactionErrorType.resetById;
  const TransactionError.confirmationByManualByAdminById(this.message)
    : type = TransactionErrorType.confirmationByManualByAdminById;

  final TransactionErrorType type;
  final String message;

  @override
  List<Object?> get props => [type, message];
}
