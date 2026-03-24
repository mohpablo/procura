import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saas_app/core/usecases/usecase.dart';
import 'package:saas_app/features/ratings/domain/usecases/get_available_ratings_usecase.dart';
import 'package:saas_app/features/ratings/domain/usecases/submit_rating_usecase.dart';
import 'rating_state.dart';

class RatingCubit extends Cubit<RatingState> {
  final GetAvailableRatingsUseCase getAvailableRatingsUseCase;
  final SubmitRatingUseCase submitRatingUseCase;

  RatingCubit({
    required this.getAvailableRatingsUseCase,
    required this.submitRatingUseCase,
  }) : super(RatingInitial());

  Future<void> loadAvailableRatings() async {
    emit(RatingLoading());
    final result = await getAvailableRatingsUseCase(NoParams());
    result.when(
      onSuccess: (ratings) => emit(RatingLoaded(ratings)),
      onFailure: (error, _) => emit(RatingError(error)),
    );
  }

  Future<void> submitRating({
    required int orderId,
    required double rating,
    String? comment,
  }) async {
    emit(RatingSubmitting());
    final result = await submitRatingUseCase(
      SubmitRatingParams(orderId: orderId, rating: rating, comment: comment),
    );
    result.when(
      onSuccess: (rating) => emit(RatingSubmitted(rating)),
      onFailure: (error, _) => emit(RatingError(error)),
    );
  }
}
