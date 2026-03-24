import 'package:saas_app/features/ratings/domain/entities/rating.dart';

abstract class RatingState {}

class RatingInitial extends RatingState {}

class RatingLoading extends RatingState {}

class RatingLoaded extends RatingState {
  final List<Rating> ratings;

  RatingLoaded(this.ratings);
}

class RatingSubmitting extends RatingState {}

class RatingSubmitted extends RatingState {
  final Rating rating;

  RatingSubmitted(this.rating);
}

class RatingError extends RatingState {
  final String message;

  RatingError(this.message);
}
