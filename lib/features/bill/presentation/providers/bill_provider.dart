import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/snackbar_service.dart';
import '../../data/datasources/bill_remote_datasource_impl.dart';
import '../../data/models/get_bill_model.dart';
import '../../data/models/create_bill_model.dart';
import '../../data/repositories/bill_repository_impl.dart';
import '../../domain/repositories/bill_repository.dart';

// Repositories
final billRemoteDataSourceProvider = Provider<BillRemoteDataSourceImpl>((ref) {
  return BillRemoteDataSourceImpl();
});

final billRepositoryProvider = Provider<BillRepository>((ref) {
  final remote = ref.watch(billRemoteDataSourceProvider);
  return BillRepositoryImpl(remoteDataSource: remote);
});

// State
class BillState {
  final bool isLoading;
  final bool billLoader;
  final bool isEmpty;
  final List<GetBillsModel>? getBillResponse;
  final CreateBillModel? createBillResponse;

  BillState({
    this.isLoading = false,
    this.billLoader = false,
    this.isEmpty = true,
    this.getBillResponse,
    this.createBillResponse,
  });

  BillState copyWith({
    bool? isLoading,
    bool? billLoader,
    bool? isEmpty,
    List<GetBillsModel>? getBillResponse,
    CreateBillModel? createBillResponse,
  }) {
    return BillState(
      isLoading: isLoading ?? this.isLoading,
      billLoader: billLoader ?? this.billLoader,
      isEmpty: isEmpty ?? this.isEmpty,
      getBillResponse: getBillResponse ?? this.getBillResponse,
      createBillResponse: createBillResponse ?? this.createBillResponse,
    );
  }
}

// Notifier
class BillNotifier extends StateNotifier<BillState> {
  final BillRepository repository;

  BillNotifier(this.repository) : super(BillState());

  Future<List<GetBillsModel>?> getBill(String consumerNumber) async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await repository.getBill(consumerNumber);
      if (response.isEmpty) {
        SnackbarService.showError("Invalid Consumer", "No Consumer Found");
        state = state.copyWith(isLoading: false, isEmpty: true, getBillResponse: response);
        return response;
      }
      state = state.copyWith(isLoading: false, isEmpty: false, getBillResponse: response);
      return response;
    } catch (e) {
      state = state.copyWith(isLoading: false, isEmpty: true);
      return null;
    }
  }

  Future<CreateBillModel?> createBill({
    required int amount,
    required int lateFeeAmount,
    required String consumerNumber,
    required String dueDate,
    required String expDate,
    required String billingMonth,
    required String email,
    required String cellNumber,
    String? consumerDetail,
    String? referenceInfo,
    String? reserved,
  }) async {
    state = state.copyWith(billLoader: true);
    try {
      final response = await repository.createBill(
        amount: amount,
        lateFeeAmount: lateFeeAmount,
        consumerNumber: consumerNumber,
        dueDate: dueDate,
        expDate: expDate,
        billingMonth: billingMonth,
        email: email,
        cellNumber: cellNumber,
        consumerDetail: consumerDetail,
        referenceInfo: referenceInfo,
        reserved: reserved,
      );
      
      state = state.copyWith(billLoader: false, createBillResponse: response);
      SnackbarService.showSuccess("Successful", "Bill Created");
      return response;
    } catch (e) {
      state = state.copyWith(billLoader: false);
      SnackbarService.showError("Invalid", "Something Went Wrong: ${e.toString()}");
      return null;
    }
  }
}

final billProvider = StateNotifierProvider<BillNotifier, BillState>((ref) {
  final repository = ref.watch(billRepositoryProvider);
  return BillNotifier(repository);
});
