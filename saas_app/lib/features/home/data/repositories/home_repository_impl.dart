import 'package:saas_app/core/network/result.dart';
import 'package:saas_app/core/errors/app_exceptions.dart';
import 'package:saas_app/features/home/domain/entities/dashboard_stats.dart';
import 'package:saas_app/features/home/domain/repositories/home_repository.dart';
import '../datasources/home_remote_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl(this.remoteDataSource);

  @override
  Future<Result<BuyerDashboardStats>> getBuyerDashboardStats() async {
    try {
      final model = await remoteDataSource.getBuyerDashboardStats();
      return Result.success(model.toEntity());
    } on ServerException catch (e) {
      return Result.failure(e.message);
    } on NetworkException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('Failed to fetch dashboard stats: ${e.toString()}');
    }
  }

  @override
  Future<Result<SupplierDashboardStats>> getSupplierDashboardStats() async {
    try {
      final model = await remoteDataSource.getSupplierDashboardStats();
      return Result.success(model.toEntity());
    } on ServerException catch (e) {
      return Result.failure(e.message);
    } on NetworkException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('Failed to fetch dashboard stats: ${e.toString()}');
    }
  }
}
