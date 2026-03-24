import 'package:saas_app/core/network/result.dart';
import 'package:saas_app/features/ratings/domain/entities/rating.dart';
import 'package:saas_app/features/ratings/domain/repositories/rating_repository.dart';
import '../datasources/rating_remote_datasource.dart';

class RatingRepositoryImpl implements RatingRepository {
  final RatingRemoteDataSource remoteDataSource;

  RatingRepositoryImpl(this.remoteDataSource);

  @override
  Future<Result<List<Rating>>> getAvailableRatings() async {
    try {
      final result = await remoteDataSource.getAvailableRatings();
      return Result.success(result.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<Rating>> submitRating({
    required int orderId,
    required double rating,
    String? comment,
  }) async {
    try {
      final result = await remoteDataSource.submitRating(
        orderId: orderId,
        rating: rating,
        comment: comment,
      );
      return Result.success(result.toEntity());
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}
