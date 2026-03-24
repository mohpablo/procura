import 'package:saas_app/core/network/result.dart';
import '../entities/dashboard_stats.dart';

abstract class HomeRepository {
  Future<Result<BuyerDashboardStats>> getBuyerDashboardStats();
  Future<Result<SupplierDashboardStats>> getSupplierDashboardStats();
}
