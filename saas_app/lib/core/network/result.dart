/// Result class for handling success and failure
sealed class Result<T> {
  const Result();

  /// Success result
  factory Result.success(T data) = Success<T>;

  /// Failure result
  factory Result.failure(String message, {String? code}) = Failure<T>;

  R when<R>({
    required R Function(T data) onSuccess,
    required R Function(String message, String? code) onFailure,
  }) {
    return switch (this) {
      Success<T>(:final data) => onSuccess(data),
      Failure<T>(:final message, :final code) => onFailure(message, code),
    };
  }

  R maybeWhen<R>({
    required R Function() orElse,
    R Function(T data)? onSuccess,
    R Function(String message, String? code)? onFailure,
  }) {
    return switch (this) {
      Success<T>(:final data) => onSuccess?.call(data) ?? orElse(),
      Failure<T>(:final message, :final code) =>
        onFailure?.call(message, code) ?? orElse(),
    };
  }

  bool get isSuccess => this is Success;
  bool get isFailure => this is Failure;

  T? getOrNull() => maybeWhen(onSuccess: (data) => data, orElse: () => null);
}

final class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);
}

final class Failure<T> extends Result<T> {
  final String message;
  final String? code;

  const Failure(this.message, {this.code});

  @override
  String toString() => 'Failure: $message (code: $code)';
}
