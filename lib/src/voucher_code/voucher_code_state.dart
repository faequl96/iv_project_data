part of 'voucher_code_cubit.dart';

class VoucherCodeState extends Equatable {
  const VoucherCodeState({
    this.isLoadingCreate = false,
    this.isLoadingGetById = false,
    this.isLoadingGetByName = false,
    this.isLoadingGets = false,
    this.isLoadingUpdateById = false,
    this.isLoadingDeleteById = false,
    this.voucherCodeById,
    this.voucherCodes,
    this.error,
  });

  final bool isLoadingCreate;
  final bool isLoadingGetById;
  final bool isLoadingGetByName;
  final bool isLoadingGets;
  final bool isLoadingUpdateById;
  final bool isLoadingDeleteById;
  final VoucherCodeResponse? voucherCodeById;
  final List<VoucherCodeResponse>? voucherCodes;

  final VoucherCodeError? error;

  VoucherCodeState copyWith({
    bool? isLoadingCreate,
    bool? isLoadingGetById,
    bool? isLoadingGetByName,
    bool? isLoadingGets,
    bool? isLoadingUpdateById,
    bool? isLoadingDeleteById,
    CopyWithValue<VoucherCodeResponse?>? voucherCodeById,
    CopyWithValue<List<VoucherCodeResponse>?>? voucherCodes,
    CopyWithValue<VoucherCodeError?>? error,
  }) {
    return VoucherCodeState(
      isLoadingCreate: isLoadingCreate ?? this.isLoadingCreate,
      isLoadingGetById: isLoadingGetById ?? this.isLoadingGetById,
      isLoadingGetByName: isLoadingGetByName ?? this.isLoadingGetByName,
      isLoadingGets: isLoadingGets ?? this.isLoadingGets,
      isLoadingUpdateById: isLoadingUpdateById ?? this.isLoadingUpdateById,
      isLoadingDeleteById: isLoadingDeleteById ?? this.isLoadingDeleteById,
      voucherCodeById: voucherCodeById != null ? voucherCodeById.value : this.voucherCodeById,
      voucherCodes: voucherCodes != null ? voucherCodes.value : this.voucherCodes,
      error: error != null ? error.value : this.error,
    );
  }

  void emitState() => GlobalContextService.value.read<VoucherCodeCubit>().emitState(this);

  @override
  List<Object?> get props => [
    isLoadingCreate,
    isLoadingGetById,
    isLoadingGetByName,
    isLoadingGets,
    isLoadingUpdateById,
    isLoadingDeleteById,
    voucherCodeById,
    voucherCodes,
    error,
  ];
}

enum VoucherCodeErrorType { create, getById, getByName, gets, updateById, deleteById }

class VoucherCodeError extends Equatable {
  const VoucherCodeError.create(this.message) : type = VoucherCodeErrorType.create;
  const VoucherCodeError.getById(this.message) : type = VoucherCodeErrorType.getById;
  const VoucherCodeError.getByName(this.message) : type = VoucherCodeErrorType.getByName;
  const VoucherCodeError.gets(this.message) : type = VoucherCodeErrorType.gets;
  const VoucherCodeError.updateById(this.message) : type = VoucherCodeErrorType.updateById;
  const VoucherCodeError.deleteById(this.message) : type = VoucherCodeErrorType.deleteById;

  final VoucherCodeErrorType type;
  final String message;

  @override
  List<Object?> get props => [type, message];
}
