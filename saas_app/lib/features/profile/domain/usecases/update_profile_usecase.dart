import 'package:saas_app/core/network/result.dart';
import 'package:saas_app/core/usecases/usecase.dart';
import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileParams {
  final Map<String, dynamic> data;

  UpdateProfileParams(this.data);
}

class UpdateProfileUseCase
    implements UseCase<UserProfile, UpdateProfileParams> {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  @override
  Future<Result<UserProfile>> call(UpdateProfileParams params) async {
    return await repository.updateProfile(params.data);
  }
}
