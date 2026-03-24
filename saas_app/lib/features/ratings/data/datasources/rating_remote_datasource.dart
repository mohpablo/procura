import 'package:saas_app/core/api/api_consumer.dart';
import 'package:saas_app/core/api/api_endpoints.dart';
import '../models/rating_model.dart';

abstract class RatingRemoteDataSource {
  Future<List<RatingModel>> getAvailableRatings();
  Future<RatingModel> submitRating({
    required int orderId,
    required double rating,
    String? comment,
  });
}

class RatingRemoteDataSourceImpl implements RatingRemoteDataSource {
  final ApiConsumer api;

  RatingRemoteDataSourceImpl(this.api);

  @override
  Future<List<RatingModel>> getAvailableRatings() async {
    try {
      final response = await api.get(
        EndPoints.availableRatings,
        withToken: true,
      );

      final List<dynamic> data = response[APIKeys.data] ?? [];
      return data
          .map((json) => RatingModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<RatingModel> submitRating({
    required int orderId,
    required double rating,
    String? comment,
  }) async {
    try {
      final response = await api.post(
        EndPoints.submitRating,
        body: {
          APIKeys.orderId: orderId,
          APIKeys.rating: rating,
          APIKeys.comment: ?comment,
        },
        withToken: true,
      );

      return RatingModel.fromJson(response[APIKeys.data]);
    } catch (e) {
      rethrow;
    }
  }
}
