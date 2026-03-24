import 'package:saas_app/core/network/result.dart';
import 'package:saas_app/core/usecases/usecase.dart';
import '../entities/rating.dart';
import '../repositories/rating_repository.dart';

class GetAvailableRatingsUseCase implements UseCase<List<Rating>, NoParams> {
  final RatingRepository repository;

  GetAvailableRatingsUseCase(this.repository);

  @override
  Future<Result<List<Rating>>> call(NoParams params) async {
    return await repository.getAvailableRatings();
  }
}
