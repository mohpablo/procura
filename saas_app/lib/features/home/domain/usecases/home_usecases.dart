import 'package:saas_app/core/network/result.dart';
import 'package:saas_app/core/usecases/usecase.dart';
import '../entities/dashboard_stats.dart';
import '../repositories/home_repository.dart';

class GetBuyerDashboardStatsUseCase
    implements NoParamUseCase<BuyerDashboardStats> {
  final HomeRepository repository;

  GetBuyerDashboardStatsUseCase(this.repository);

  @override
  Future<Result<BuyerDashboardStats>> call() async {
    return await repository.getBuyerDashboardStats();
  }
}

class GetSupplierDashboardStatsUseCase
    implements NoParamUseCase<SupplierDashboardStats> {
  final HomeRepository repository;

  GetSupplierDashboardStatsUseCase(this.repository);

  @override
  Future<Result<SupplierDashboardStats>> call() async {
    return await repository.getSupplierDashboardStats();
  }
}
