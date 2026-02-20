import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iv_project_api_core/iv_project_api_core.dart';
import 'package:iv_project_core/iv_project_core.dart';
import 'package:iv_project_model/iv_project_model.dart';
import 'package:iv_project_repository/iv_project_repository.dart';

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
       super(const TransactionState());

  final TransactionRepository _repository;
  final TransactionPaymentRepository _transactionPaymentRepository;
  final TransactionStatusRepository _transactionStatusRepository;

  void emitState(TransactionState state) => emit(state);

  List<List<TransactionResponse>> _getNewTransactions(TransactionResponse transaction, {bool isCreate = false}) {
    final newTransactionsByUserIdByStatusFinished = <TransactionResponse>[];
    final newTransactionsByUserIdByStatusUnfinished = <TransactionResponse>[];

    if (isCreate) {
      newTransactionsByUserIdByStatusUnfinished.add(transaction);
      newTransactionsByUserIdByStatusUnfinished.addAll(state.transactionsByUserIdByStatusUnfinished ?? <TransactionResponse>[]);
    } else {
      final transactionsIdFinished = state.transactionsByUserIdByStatusFinished?.map((e) => e.id).toList() ?? [];
      if (!transactionsIdFinished.contains(transaction.id)) newTransactionsByUserIdByStatusFinished.add(transaction);
      for (final item in state.transactionsByUserIdByStatusFinished ?? <TransactionResponse>[]) {
        if (item.id == transaction.id) newTransactionsByUserIdByStatusFinished.add(transaction);
        if (item.id == transaction.id) continue;
        newTransactionsByUserIdByStatusFinished.add(item);
      }

      for (final item in state.transactionsByUserIdByStatusUnfinished ?? <TransactionResponse>[]) {
        if (item.id == transaction.id && transaction.status != .confirmed) {
          newTransactionsByUserIdByStatusUnfinished.add(transaction);
        }
        if (item.id == transaction.id) continue;
        newTransactionsByUserIdByStatusUnfinished.add(item);
      }
    }

    return [newTransactionsByUserIdByStatusFinished, newTransactionsByUserIdByStatusUnfinished];
  }

  Future<bool> create(CreateTransactionRequest request) async {
    try {
      emit(state.copyWith(isLoadingCreate: true, transaction: null.toCopyWithValue(), error: null.toCopyWithValue()));
      final transaction = await _repository.create(request);
      final newTransactions = _getNewTransactions(transaction, isCreate: true);
      emit(
        state.copyWith(
          isLoadingCreate: false,
          transaction: transaction.toCopyWithValue(),
          transactionsByUserIdByStatusUnfinished: newTransactions[1].toCopyWithValue(),
        ),
      );

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
      emit(state.copyWith(isLoadingGetById: true, transaction: null.toCopyWithValue(), error: null.toCopyWithValue()));
      final transaction = await _repository.getById(id);
      final newTransactions = _getNewTransactions(transaction);
      emit(
        state.copyWith(
          isLoadingGetById: false,
          transaction: transaction.toCopyWithValue(),
          transactionsByUserIdByStatusFinished: newTransactions[0].toCopyWithValue(),
          transactionsByUserIdByStatusUnfinished: newTransactions[1].toCopyWithValue(),
        ),
      );

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
      final transaction = await _repository.getByReferenceNumber(referenceNumber);
      final newTransactions = _getNewTransactions(transaction);
      emit(
        state.copyWith(
          isLoadingGetByReferenceNumber: false,
          transaction: transaction.toCopyWithValue(),
          transactionsByUserIdByStatusFinished: newTransactions[0].toCopyWithValue(),
          transactionsByUserIdByStatusUnfinished: newTransactions[1].toCopyWithValue(),
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
      final transactions = await _repository.gets(
        query: QueryRequest(
          page: page,
          limit: limit,
          filterGroups: [
            FilterGroup(
              joinType: .and,
              filters: [Filter(field: 'user_id', operator: .equals, value: userId)],
            ),
            FilterGroup(
              joinType: .or,
              filters: [Filter(field: 'status', operator: .equals, value: TransactionStatusType.confirmed.toJson())],
            ),
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
      emit(
        state.copyWith(
          isLoadingGetsByUserIdByStatusFinished: false,
          error: TransactionError.getsByUserIdByStatusFinished(message).toCopyWithValue(),
        ),
      );

      return false;
    }
  }

  Future<bool> getsByUserIdByStatusUnfinished(String userId) async {
    try {
      emit(state.copyWith(isLoadingGetsByUserIdByStatusUnfinished: true, error: null.toCopyWithValue()));
      final transactions = await _repository.gets(
        query: QueryRequest(
          page: 1,
          limit: 10,
          filterGroups: [
            FilterGroup(
              joinType: .and,
              filters: [Filter(field: 'user_id', operator: .equals, value: userId)],
            ),
            FilterGroup(
              joinType: .or,
              filters: [
                Filter(field: 'status', operator: .equals, value: TransactionStatusType.created.toJson()),
                Filter(field: 'status', operator: .equals, value: TransactionStatusType.pending.toJson()),
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
        state.copyWith(
          isLoadingGetsByUserIdByStatusUnfinished: false,
          error: TransactionError.getsByUserIdByStatusUnfinished(message).toCopyWithValue(),
        ),
      );

      return false;
    }
  }

  Future<bool> updateById(String id, UpdateTransactionRequest request) async {
    try {
      emit(state.copyWith(isLoadingUpdateById: true, error: null.toCopyWithValue()));
      final transaction = await _repository.updateById(id, request);
      final newTransactions = _getNewTransactions(transaction);
      emit(
        state.copyWith(
          isLoadingUpdateById: false,
          transaction: transaction.toCopyWithValue(),
          transactionsByUserIdByStatusFinished: newTransactions[0].toCopyWithValue(),
          transactionsByUserIdByStatusUnfinished: newTransactions[1].toCopyWithValue(),
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

  Future<bool> issueById(String id) async {
    try {
      emit(state.copyWith(isLoadingIssueById: true, error: null.toCopyWithValue()));
      final transaction = await _transactionPaymentRepository.issueById(id);
      final newTransactions = _getNewTransactions(transaction);
      emit(
        state.copyWith(
          isLoadingIssueById: false,
          transaction: transaction.toCopyWithValue(),
          transactionsByUserIdByStatusFinished: newTransactions[0].toCopyWithValue(),
          transactionsByUserIdByStatusUnfinished: newTransactions[1].toCopyWithValue(),
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
      final transaction = await _transactionStatusRepository.checkByReferenceNumber(referenceNumber);
      final newTransactions = _getNewTransactions(transaction);
      emit(
        state.copyWith(
          isLoadingCheckById: false,
          transaction: transaction.toCopyWithValue(),
          transactionsByUserIdByStatusFinished: newTransactions[0].toCopyWithValue(),
          transactionsByUserIdByStatusUnfinished: newTransactions[1].toCopyWithValue(),
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
      final transaction = await _transactionStatusRepository.resetById(id);
      final newTransactions = _getNewTransactions(transaction);
      emit(
        state.copyWith(
          isLoadingResetById: false,
          transaction: transaction.toCopyWithValue(),
          transactionsByUserIdByStatusFinished: newTransactions[0].toCopyWithValue(),
          transactionsByUserIdByStatusUnfinished: newTransactions[1].toCopyWithValue(),
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
