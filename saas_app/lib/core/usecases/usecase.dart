import 'package:saas_app/core/network/result.dart';

/// Base class for all Use Cases
abstract class UseCase<T, Params> {
  Future<Result<T>> call(Params params);
}

/// Base class for Use Cases with no parameters
abstract class NoParamUseCase<T> {
  Future<Result<T>> call();
}

/// Empty params class for use cases that don't need parameters
class NoParams {
  const NoParams();
}
