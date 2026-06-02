import '../../domain/repositories/bill_repository.dart';
import '../datasources/bill_remote_datasource.dart';
import '../models/get_bill_model.dart';
import '../models/create_bill_model.dart';

class BillRepositoryImpl implements BillRepository {
  final BillRemoteDataSource remoteDataSource;

  BillRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<GetBillsModel>> getBill(String consumerNumber) {
    return remoteDataSource.getBill(consumerNumber);
  }

  @override
  Future<CreateBillModel> createBill({
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
  }) {
    return remoteDataSource.createBill(
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
  }
}
