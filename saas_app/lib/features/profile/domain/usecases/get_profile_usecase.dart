import 'package:saas_app/core/network/result.dart';
import 'package:saas_app/core/usecases/usecase.dart';
import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

class GetProfileUseCase implements UseCase<UserProfile, NoParams> {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  @override
  Future<Result<UserProfile>> call(NoParams params) async {
    return await repository.getProfile();
  }
}
