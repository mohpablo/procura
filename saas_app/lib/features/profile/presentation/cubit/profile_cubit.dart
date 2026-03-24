import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saas_app/core/usecases/usecase.dart';
import 'package:saas_app/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:saas_app/features/profile/domain/usecases/update_profile_usecase.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;

  ProfileCubit({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
  }) : super(ProfileInitial());

  Future<void> loadProfile() async {
    emit(ProfileLoading());
    final result = await getProfileUseCase(NoParams());
    result.when(
      onSuccess: (profile) => emit(ProfileLoaded(profile)),
      onFailure: (error, _) => emit(ProfileError(error)),
    );
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    emit(ProfileLoading());
    final result = await updateProfileUseCase(UpdateProfileParams(data));
    result.when(
      onSuccess: (profile) => emit(ProfileUpdated(profile)),
      onFailure: (error, _) => emit(ProfileError(error)),
    );
  }
}
