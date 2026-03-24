import 'package:saas_app/core/api/api_endpoints.dart';
import 'package:saas_app/core/api/api_consumer.dart';
import '../models/dashboard_stats_model.dart';

class HomeRemoteDataSource {
  final ApiConsumer api;

  HomeRemoteDataSource(this.api);

  Future<BuyerDashboardStatsModel> getBuyerDashboardStats() async {
    try {
      final response = await api.get(
        EndPoints.buyerStatistics,
        withToken: true,
      );
      return BuyerDashboardStatsModel.fromJson(response['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<SupplierDashboardStatsModel> getSupplierDashboardStats() async {
    try {
      final response = await api.get(
        EndPoints.supplierDashboardOverview,
        withToken: true,
      );
      return SupplierDashboardStatsModel.fromJson(response['data']);
    } catch (e) {
      rethrow;
    }
  }
}
