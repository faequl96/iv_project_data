import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iv_project_api_core/iv_project_api_core.dart';
import 'package:iv_project_core/iv_project_core.dart';
import 'package:iv_project_model/iv_project_model.dart';
import 'package:iv_project_repository/iv_project_repository.dart';

part 'transaction_request.dart';
part 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  TransactionCubit({
    required TransactionRepository repository,
    required TransactionPaymentRepository transactionPaymentRepository,
    required TransactionStatusRepository transactionStatusRepository,
    required TransactionConfirmationRepository transactionConfirmationRepository,
  }) : _repository = repository,
       _transactionPaymentRepository = transactionPaymentRepository,
       _transactionStatusRepository = transactionStatusRepository,
       _transactionConfirmationRepository = transactionConfirmationRepository,
       super(const TransactionState());

  final TransactionRepository _repository;
  final TransactionPaymentRepository _transactionPaymentRepository;
  final TransactionStatusRepository _transactionStatusRepository;
  final TransactionConfirmationRepository _transactionConfirmationRepository;

  void emitState(TransactionState state) => emit(state);

  Future<bool> create(TransactionCreateRequest request) async {
    try {
      emit(state.copyWith(isLoadingCreate: true, error: null.toCopyWithValue()));
      await _repository.create(
        CreateTransactionRequest(productType: request.productType, productId: request.productId, userId: request.userId),
      );
      emit(state.copyWith(isLoadingCreate: false));

      return true;
    } catch (e) {
      final message = MessageService.getFromException(
        e is Exception ? e : Exception(AppLocalization.translate('common.error.thereIsAnError')),
      );
      emit(state.copyWith(isLoadingCreate: false, error: TransactionError.create(message).toCopyWithValue()));

      return false;
    }
  }

  Future<bool> getById(String id) async {
    try {
      emit(state.copyWith(isLoadingGetById: true, error: null.toCopyWithValue()));
      final TransactionResponse transaction = await _repository.getById(id);
      emit(state.copyWith(isLoadingGetById: false, transactionById: transaction.toCopyWithValue()));

      return true;
    } catch (e) {
      final message = MessageService.getFromException(
        e is Exception ? e : Exception(AppLocalization.translate('common.error.thereIsAnError')),
      );
      emit(state.copyWith(isLoadingGetById: false, error: TransactionError.getById(message).toCopyWithValue()));

      return false;
    }
  }

  Future<bool> getByReferenceNumber(String referenceNumber) async {
    try {
      emit(state.copyWith(isLoadingGetByReferenceNumber: true, error: null.toCopyWithValue()));
      final TransactionResponse transaction = await _repository.getByReferenceNumber(referenceNumber);
      final newTransactions = <TransactionResponse>[];
      for (final item in state.transactions ?? <TransactionResponse>[]) {
        if (item.id == transaction.id) newTransactions.add(transaction);
        if (item.id == transaction.id) continue;
        newTransactions.add(item);
      }
      final newTransactionsByUserId = <TransactionResponse>[];
      for (final item in state.transactionsByUserId ?? <TransactionResponse>[]) {
        if (item.id == transaction.id) newTransactionsByUserId.add(transaction);
        if (item.id == transaction.id) continue;
        newTransactionsByUserId.add(item);
      }
      final newTransactionsByUserIdByStatusFinished = <TransactionResponse>[];
      for (final item in state.transactionsByUserIdByStatusFinished ?? <TransactionResponse>[]) {
        if (item.id == transaction.id) newTransactionsByUserIdByStatusFinished.add(transaction);
        if (item.id == transaction.id) continue;
        newTransactionsByUserIdByStatusFinished.add(item);
      }
      final newTransactionsByUserIdByStatusUnfinished = <TransactionResponse>[];
      for (final item in state.transactionsByUserIdByStatusUnfinished ?? <TransactionResponse>[]) {
        if (item.id == transaction.id) newTransactionsByUserIdByStatusUnfinished.add(transaction);
        if (item.id == transaction.id) continue;
        newTransactionsByUserIdByStatusUnfinished.add(item);
      }
      emit(
        state.copyWith(
          isLoadingGetByReferenceNumber: false,
          transactionById: transaction.toCopyWithValue(),
          transactions: newTransactions.toCopyWithValue(),
          transactionsByUserId: newTransactionsByUserId.toCopyWithValue(),
          transactionsByUserIdByStatusFinished: newTransactionsByUserIdByStatusFinished.toCopyWithValue(),
          transactionsByUserIdByStatusUnfinished: newTransactionsByUserIdByStatusUnfinished.toCopyWithValue(),
        ),
      );

      return true;
    } catch (e) {
      final message = MessageService.getFromException(
        e is Exception ? e : Exception(AppLocalization.translate('common.error.thereIsAnError')),
      );
      emit(
        state.copyWith(
          isLoadingGetByReferenceNumber: false,
          error: TransactionError.getByReferenceNumber(message).toCopyWithValue(),
        ),
      );

      return false;
    }
  }

  Future<bool> gets({QueryRequest? query}) async {
    try {
      emit(state.copyWith(isLoadingGets: true, error: null.toCopyWithValue()));
      final List<TransactionResponse> transactions = await _repository.gets(query: query);
      if (query == null) emit(state.copyWith(isLoadingGets: false, transactions: transactions.toCopyWithValue()));
      if (query != null) emit(state.copyWith(isLoadingGets: false, transactionsBySearch: transactions.toCopyWithValue()));

      return true;
    } catch (e) {
      final message = MessageService.getFromException(
        e is Exception ? e : Exception(AppLocalization.translate('common.error.thereIsAnError')),
      );
      emit(state.copyWith(isLoadingGets: false, error: TransactionError.gets(message).toCopyWithValue()));

      return false;
    }
  }

  Future<bool> getsByUserId(String userId) async {
    try {
      emit(state.copyWith(isLoadingGetsByUserId: true, error: null.toCopyWithValue()));
      final List<TransactionResponse> transactions = await _repository.getsByUserId(userId);
      emit(state.copyWith(isLoadingGetsByUserId: false, transactionsByUserId: transactions.toCopyWithValue()));

      return true;
    } catch (e) {
      final message = MessageService.getFromException(
        e is Exception ? e : Exception(AppLocalization.translate('common.error.thereIsAnError')),
      );
      emit(state.copyWith(isLoadingGetsByUserId: false, error: TransactionError.getsByUserId(message).toCopyWithValue()));

      return false;
    }
  }

  Future<bool> getsByUserIdByStatusFinished(
    String userId, {
    required int page,
    required int limit,
    void Function()? infiniteScrollMax,
  }) async {
    try {
      emit(
        state.copyWith(
          isLoadingGetsByUserIdByStatusFinished: true,
          transactionsByUserIdByStatusFinished: page == 1
              ? null.toCopyWithValue()
              : state.transactionsByUserIdByStatusFinished.toCopyWithValue(),
          error: null.toCopyWithValue(),
        ),
      );
      await Future.delayed(const Duration(seconds: 3));
      final List<TransactionResponse> transactions = await _repository.gets(
        query: QueryRequest(
          page: page,
          limit: limit,
          filterGroups: [
            FilterGroup(
              joinType: JoinType.and,
              filters: [Filter(field: 'user_id', operator: OperatorType.equals, value: userId)],
            ),
            // FilterGroup(
            //   joinType: JoinType.or,
            //   filters: [Filter(field: 'status', operator: OperatorType.equals, value: TransactionStatusType.confirmed.toJson())],
            // ),
          ],
        ),
      );
      if (transactions.length < limit) infiniteScrollMax?.call();

      List<TransactionResponse> newTransactions = [];
      if (page == 1) {
        newTransactions = transactions;
      } else {
        newTransactions = [...(state.transactionsByUserIdByStatusFinished ?? []), ...transactions];
      }
      emit(
        state.copyWith(
          isLoadingGetsByUserIdByStatusFinished: false,
          transactionsByUserIdByStatusFinished: newTransactions.toCopyWithValue(),
        ),
      );

      return true;
    } catch (e) {
      final message = MessageService.getFromException(
        e is Exception ? e : Exception(AppLocalization.translate('common.error.thereIsAnError')),
      );
      emit(state.copyWith(isLoadingGetsByUserIdByStatusFinished: false, error: TransactionError.gets(message).toCopyWithValue()));

      return false;
    }
  }

  Future<bool> getsByUserIdByStatusUnfinished(String userId) async {
    try {
      emit(state.copyWith(isLoadingGetsByUserIdByStatusUnfinished: true, error: null.toCopyWithValue()));
      final List<TransactionResponse> transactions = await _repository.gets(
        query: QueryRequest(
          page: 1,
          limit: 10,
          filterGroups: [
            FilterGroup(
              joinType: JoinType.and,
              filters: [Filter(field: 'user_id', operator: OperatorType.equals, value: userId)],
            ),
            FilterGroup(
              joinType: JoinType.or,
              filters: [
                Filter(field: 'status', operator: OperatorType.equals, value: TransactionStatusType.created.toJson()),
                Filter(field: 'status', operator: OperatorType.equals, value: TransactionStatusType.pending.toJson()),
              ],
            ),
          ],
        ),
      );
      emit(
        state.copyWith(
          isLoadingGetsByUserIdByStatusUnfinished: false,
          transactionsByUserIdByStatusUnfinished: transactions.toCopyWithValue(),
        ),
      );

      return true;
    } catch (e) {
      final message = MessageService.getFromException(
        e is Exception ? e : Exception(AppLocalization.translate('common.error.thereIsAnError')),
      );
      emit(
        state.copyWith(isLoadingGetsByUserIdByStatusUnfinished: false, error: TransactionError.gets(message).toCopyWithValue()),
      );

      return false;
    }
  }

  Future<bool> updateById(String id, TransactionUpdateRequest request) async {
    try {
      emit(state.copyWith(isLoadingUpdateById: true, error: null.toCopyWithValue()));
      final TransactionResponse transaction = await _repository.updateById(
        id,
        UpdateTransactionRequest(paymentMethod: request.paymentMethod, voucherCodeName: request.voucherCodeName),
      );
      final newTransactions = <TransactionResponse>[];
      for (final item in state.transactions ?? <TransactionResponse>[]) {
        if (item.id == transaction.id) newTransactions.add(transaction);
        if (item.id == transaction.id) continue;
        newTransactions.add(item);
      }
      final newTransactionsByUserId = <TransactionResponse>[];
      for (final item in state.transactionsByUserId ?? <TransactionResponse>[]) {
        if (item.id == transaction.id) newTransactionsByUserId.add(transaction);
        if (item.id == transaction.id) continue;
        newTransactionsByUserId.add(item);
      }
      final newTransactionsByUserIdByStatusFinished = <TransactionResponse>[];
      for (final item in state.transactionsByUserIdByStatusFinished ?? <TransactionResponse>[]) {
        if (item.id == transaction.id) newTransactionsByUserIdByStatusFinished.add(transaction);
        if (item.id == transaction.id) continue;
        newTransactionsByUserIdByStatusFinished.add(item);
      }
      final newTransactionsByUserIdByStatusUnfinished = <TransactionResponse>[];
      for (final item in state.transactionsByUserIdByStatusUnfinished ?? <TransactionResponse>[]) {
        if (item.id == transaction.id) newTransactionsByUserIdByStatusUnfinished.add(transaction);
        if (item.id == transaction.id) continue;
        newTransactionsByUserIdByStatusUnfinished.add(item);
      }
      emit(
        state.copyWith(
          isLoadingUpdateById: false,
          transactionById: transaction.toCopyWithValue(),
          transactions: newTransactions.toCopyWithValue(),
          transactionsByUserId: newTransactionsByUserId.toCopyWithValue(),
          transactionsByUserIdByStatusFinished: newTransactionsByUserIdByStatusFinished.toCopyWithValue(),
          transactionsByUserIdByStatusUnfinished: newTransactionsByUserIdByStatusUnfinished.toCopyWithValue(),
        ),
      );

      return true;
    } catch (e) {
      final message = MessageService.getFromException(
        e is Exception ? e : Exception(AppLocalization.translate('common.error.thereIsAnError')),
      );
      emit(state.copyWith(isLoadingUpdateById: false, error: TransactionError.updateById(message).toCopyWithValue()));

      return false;
    }
  }

  Future<bool> deleteById(String id) async {
    try {
      emit(state.copyWith(isLoadingDeleteById: true, error: null.toCopyWithValue()));
      await _repository.deleteById(id);
      final newTransactions = <TransactionResponse>[];
      for (final item in state.transactions ?? <TransactionResponse>[]) {
        newTransactions.add(item);
      }
      newTransactions.removeWhere((item) => item.id == id);

      final newTransactionsByUserId = <TransactionResponse>[];
      for (final item in state.transactionsByUserId ?? <TransactionResponse>[]) {
        newTransactionsByUserId.add(item);
      }
      newTransactionsByUserId.removeWhere((item) => item.id == id);

      final newTransactionsByUserIdByStatusFinished = <TransactionResponse>[];
      for (final item in state.transactionsByUserIdByStatusFinished ?? <TransactionResponse>[]) {
        newTransactionsByUserIdByStatusFinished.add(item);
      }
      newTransactionsByUserIdByStatusFinished.removeWhere((item) => item.id == id);

      final newTransactionsByUserIdByStatusUnfinished = <TransactionResponse>[];
      for (final item in state.transactionsByUserIdByStatusUnfinished ?? <TransactionResponse>[]) {
        newTransactionsByUserIdByStatusUnfinished.add(item);
      }
      newTransactionsByUserIdByStatusUnfinished.removeWhere((item) => item.id == id);

      emit(
        state.copyWith(
          isLoadingDeleteById: false,
          transactionById: null,
          transactions: newTransactions.toCopyWithValue(),
          transactionsByUserId: newTransactionsByUserId.toCopyWithValue(),
          transactionsByUserIdByStatusFinished: newTransactionsByUserIdByStatusFinished.toCopyWithValue(),
          transactionsByUserIdByStatusUnfinished: newTransactionsByUserIdByStatusUnfinished.toCopyWithValue(),
        ),
      );

      return true;
    } catch (e) {
      final message = MessageService.getFromException(
        e is Exception ? e : Exception(AppLocalization.translate('common.error.thereIsAnError')),
      );
      emit(state.copyWith(isLoadingDeleteById: false, error: TransactionError.deleteById(message).toCopyWithValue()));

      return false;
    }
  }

  Future<bool> issueById(String id) async {
    try {
      emit(state.copyWith(isLoadingIssueById: true, error: null.toCopyWithValue()));
      final TransactionResponse transaction = await _transactionPaymentRepository.issueById(id);
      final newTransactions = <TransactionResponse>[];
      for (final item in state.transactions ?? <TransactionResponse>[]) {
        if (item.id == transaction.id) newTransactions.add(transaction);
        if (item.id == transaction.id) continue;
        newTransactions.add(item);
      }
      final newTransactionsByUserId = <TransactionResponse>[];
      for (final item in state.transactionsByUserId ?? <TransactionResponse>[]) {
        if (item.id == transaction.id) newTransactionsByUserId.add(transaction);
        if (item.id == transaction.id) continue;
        newTransactionsByUserId.add(item);
      }
      final newTransactionsByUserIdByStatusFinished = <TransactionResponse>[];
      for (final item in state.transactionsByUserIdByStatusFinished ?? <TransactionResponse>[]) {
        if (item.id == transaction.id) newTransactionsByUserIdByStatusFinished.add(transaction);
        if (item.id == transaction.id) continue;
        newTransactionsByUserIdByStatusFinished.add(item);
      }
      final newTransactionsByUserIdByStatusUnfinished = <TransactionResponse>[];
      for (final item in state.transactionsByUserIdByStatusUnfinished ?? <TransactionResponse>[]) {
        if (item.id == transaction.id) newTransactionsByUserIdByStatusUnfinished.add(transaction);
        if (item.id == transaction.id) continue;
        newTransactionsByUserIdByStatusUnfinished.add(item);
      }
      emit(
        state.copyWith(
          isLoadingIssueById: false,
          transactionById: transaction.toCopyWithValue(),
          transactions: newTransactions.toCopyWithValue(),
          transactionsByUserId: newTransactionsByUserId.toCopyWithValue(),
          transactionsByUserIdByStatusFinished: newTransactionsByUserIdByStatusFinished.toCopyWithValue(),
          transactionsByUserIdByStatusUnfinished: newTransactionsByUserIdByStatusUnfinished.toCopyWithValue(),
        ),
      );

      return true;
    } catch (e) {
      final message = MessageService.getFromException(
        e is Exception ? e : Exception(AppLocalization.translate('common.error.thereIsAnError')),
      );
      emit(state.copyWith(isLoadingIssueById: false, error: TransactionError.issueById(message).toCopyWithValue()));

      return false;
    }
  }

  Future<bool> checkByReferenceNumber(String referenceNumber) async {
    try {
      emit(state.copyWith(isLoadingCheckById: true, error: null.toCopyWithValue()));
      final TransactionResponse transaction = await _transactionStatusRepository.checkByReferenceNumber(referenceNumber);
      final newTransactions = <TransactionResponse>[];
      for (final item in state.transactions ?? <TransactionResponse>[]) {
        if (item.id == transaction.id) newTransactions.add(transaction);
        if (item.id == transaction.id) continue;
        newTransactions.add(item);
      }
      final newTransactionsByUserId = <TransactionResponse>[];
      for (final item in state.transactionsByUserId ?? <TransactionResponse>[]) {
        if (item.id == transaction.id) newTransactionsByUserId.add(transaction);
        if (item.id == transaction.id) continue;
        newTransactionsByUserId.add(item);
      }
      final newTransactionsByUserIdByStatusFinished = <TransactionResponse>[];
      for (final item in state.transactionsByUserIdByStatusFinished ?? <TransactionResponse>[]) {
        if (item.id == transaction.id) newTransactionsByUserIdByStatusFinished.add(transaction);
        if (item.id == transaction.id) continue;
        newTransactionsByUserIdByStatusFinished.add(item);
      }
      final newTransactionsByUserIdByStatusUnfinished = <TransactionResponse>[];
      for (final item in state.transactionsByUserIdByStatusUnfinished ?? <TransactionResponse>[]) {
        if (item.id == transaction.id) newTransactionsByUserIdByStatusUnfinished.add(transaction);
        if (item.id == transaction.id) continue;
        newTransactionsByUserIdByStatusUnfinished.add(item);
      }
      emit(
        state.copyWith(
          isLoadingCheckById: false,
          transactionById: transaction.toCopyWithValue(),
          transactions: newTransactions.toCopyWithValue(),
          transactionsByUserId: newTransactionsByUserId.toCopyWithValue(),
          transactionsByUserIdByStatusFinished: newTransactionsByUserIdByStatusFinished.toCopyWithValue(),
          transactionsByUserIdByStatusUnfinished: newTransactionsByUserIdByStatusUnfinished.toCopyWithValue(),
        ),
      );

      return true;
    } catch (e) {
      final message = MessageService.getFromException(
        e is Exception ? e : Exception(AppLocalization.translate('common.error.thereIsAnError')),
      );
      emit(state.copyWith(isLoadingCheckById: false, error: TransactionError.checkById(message).toCopyWithValue()));

      return false;
    }
  }

  Future<bool> resetById(String id) async {
    try {
      emit(state.copyWith(isLoadingResetById: true, error: null.toCopyWithValue()));
      final TransactionResponse transaction = await _transactionStatusRepository.resetById(id);
      final newTransactions = <TransactionResponse>[];
      for (final item in state.transactions ?? <TransactionResponse>[]) {
        if (item.id == transaction.id) newTransactions.add(transaction);
        if (item.id == transaction.id) continue;
        newTransactions.add(item);
      }
      final newTransactionsByUserId = <TransactionResponse>[];
      for (final item in state.transactionsByUserId ?? <TransactionResponse>[]) {
        if (item.id == transaction.id) newTransactionsByUserId.add(transaction);
        if (item.id == transaction.id) continue;
        newTransactionsByUserId.add(item);
      }
      final newTransactionsByUserIdByStatusFinished = <TransactionResponse>[];
      for (final item in state.transactionsByUserIdByStatusFinished ?? <TransactionResponse>[]) {
        if (item.id == transaction.id) newTransactionsByUserIdByStatusFinished.add(transaction);
        if (item.id == transaction.id) continue;
        newTransactionsByUserIdByStatusFinished.add(item);
      }
      final newTransactionsByUserIdByStatusUnfinished = <TransactionResponse>[];
      for (final item in state.transactionsByUserIdByStatusUnfinished ?? <TransactionResponse>[]) {
        if (item.id == transaction.id) newTransactionsByUserIdByStatusUnfinished.add(transaction);
        if (item.id == transaction.id) continue;
        newTransactionsByUserIdByStatusUnfinished.add(item);
      }
      emit(
        state.copyWith(
          isLoadingResetById: false,
          transactionById: transaction.toCopyWithValue(),
          transactions: newTransactions.toCopyWithValue(),
          transactionsByUserId: newTransactionsByUserId.toCopyWithValue(),
          transactionsByUserIdByStatusFinished: newTransactionsByUserIdByStatusFinished.toCopyWithValue(),
          transactionsByUserIdByStatusUnfinished: newTransactionsByUserIdByStatusUnfinished.toCopyWithValue(),
        ),
      );

      return true;
    } catch (e) {
      final message = MessageService.getFromException(
        e is Exception ? e : Exception(AppLocalization.translate('common.error.thereIsAnError')),
      );
      emit(state.copyWith(isLoadingResetById: false, error: TransactionError.resetById(message).toCopyWithValue()));

      return false;
    }
  }

  Future<bool> confirmationByManualByAdminById(String id, TransactionStatusType status) async {
    try {
      emit(state.copyWith(isLoadingResetById: true, error: null.toCopyWithValue()));
      final TransactionResponse transaction = await _transactionConfirmationRepository.manualByAdminById(
        id,
        TransactionConfirmationRequest(status: status),
      );
      final newTransactions = <TransactionResponse>[];
      for (final item in state.transactions ?? <TransactionResponse>[]) {
        if (item.id == transaction.id) newTransactions.add(transaction);
        if (item.id == transaction.id) continue;
        newTransactions.add(item);
      }
      final newTransactionsByUserId = <TransactionResponse>[];
      for (final item in state.transactionsByUserId ?? <TransactionResponse>[]) {
        if (item.id == transaction.id) newTransactionsByUserId.add(transaction);
        if (item.id == transaction.id) continue;
        newTransactionsByUserId.add(item);
      }
      final newTransactionsByUserIdByStatusFinished = <TransactionResponse>[];
      for (final item in state.transactionsByUserIdByStatusFinished ?? <TransactionResponse>[]) {
        if (item.id == transaction.id) newTransactionsByUserIdByStatusFinished.add(transaction);
        if (item.id == transaction.id) continue;
        newTransactionsByUserIdByStatusFinished.add(item);
      }
      final newTransactionsByUserIdByStatusUnfinished = <TransactionResponse>[];
      for (final item in state.transactionsByUserIdByStatusUnfinished ?? <TransactionResponse>[]) {
        if (item.id == transaction.id) newTransactionsByUserIdByStatusUnfinished.add(transaction);
        if (item.id == transaction.id) continue;
        newTransactionsByUserIdByStatusUnfinished.add(item);
      }
      emit(
        state.copyWith(
          isLoadingResetById: false,
          transactionById: transaction.toCopyWithValue(),
          transactions: newTransactions.toCopyWithValue(),
          transactionsByUserId: newTransactionsByUserId.toCopyWithValue(),
          transactionsByUserIdByStatusFinished: newTransactionsByUserIdByStatusFinished.toCopyWithValue(),
          transactionsByUserIdByStatusUnfinished: newTransactionsByUserIdByStatusUnfinished.toCopyWithValue(),
        ),
      );

      return true;
    } catch (e) {
      final message = MessageService.getFromException(
        e is Exception ? e : Exception(AppLocalization.translate('common.error.thereIsAnError')),
      );
      emit(state.copyWith(isLoadingResetById: false, error: TransactionError.resetById(message).toCopyWithValue()));

      return false;
    }
  }
}
