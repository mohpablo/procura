import 'package:saas_app/core/network/result.dart';
import 'package:saas_app/core/usecases/usecase.dart';
import '../entities/rating.dart';
import '../repositories/rating_repository.dart';

class SubmitRatingParams {
  final int orderId;
  final double rating;
  final String? comment;

  SubmitRatingParams({
    required this.orderId,
    required this.rating,
    this.comment,
  });
}

class SubmitRatingUseCase implements UseCase<Rating, SubmitRatingParams> {
  final RatingRepository repository;

  SubmitRatingUseCase(this.repository);

  @override
  Future<Result<Rating>> call(SubmitRatingParams params) async {
    return await repository.submitRating(
      orderId: params.orderId,
      rating: params.rating,
      comment: params.comment,
    );
  }
}
