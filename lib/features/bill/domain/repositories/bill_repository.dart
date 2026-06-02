import '../../data/models/get_bill_model.dart';
import '../../data/models/create_bill_model.dart';

abstract class BillRepository {
  Future<List<GetBillsModel>> getBill(String consumerNumber);
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
  });
}
