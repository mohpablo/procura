import 'package:saas_app/core/network/result.dart';
import '../entities/rating.dart';

abstract class RatingRepository {
  Future<Result<List<Rating>>> getAvailableRatings();
  Future<Result<Rating>> submitRating({
    required int orderId,
    required double rating,
    String? comment,
  });
}
