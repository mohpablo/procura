import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saas_app/core/routes/app_routes.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';

class ProfileView extends StatefulWidget {
  static const String routeName = '/buyer/profile';

  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async => context.read<ProfileCubit>().loadProfile(),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverAppBar(
                  expandedHeight: 120,
                  pinned: true,
                  flexibleSpace: const FlexibleSpaceBar(
                    title: Text(
                      'Account Profile',
                      style: TextStyle(
                        color: Color(0xFF1E293B),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    centerTitle: false,
                  ),
                  backgroundColor: Colors.white,
                  elevation: 0,
                  actions: [
                    IconButton(
                      icon: const Icon(
                        Icons.logout_rounded,
                        color: Colors.redAccent,
                      ),
                      onPressed: () => _showLogoutDialog(context),
                    ),
                  ],
                ),
                if (state is ProfileLoading)
                  const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (state is ProfileError)
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(state.message),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<ProfileCubit>().loadProfile();
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  )
                else if (state is ProfileLoaded || state is ProfileUpdated)
                  SliverToBoxAdapter(
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF6366F1),
                                  width: 2,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: const Color(
                                  0xFF6366F1,
                                ).withValues(alpha: 0.1),
                                child: Text(
                                  (state is ProfileLoaded
                                          ? state.profile.name
                                          : (state as ProfileUpdated)
                                                .profile
                                                .name)[0]
                                      .toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF6366F1),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          _buildInfoCard(
                            'Display Name',
                            (state is ProfileLoaded
                                ? state.profile.name
                                : (state as ProfileUpdated).profile.name),
                            Icons.person_outline_rounded,
                          ),
                          _buildInfoCard(
                            'Email Address',
                            (state is ProfileLoaded
                                ? state.profile.email
                                : (state as ProfileUpdated).profile.email),
                            Icons.email_outlined,
                          ),
                          _buildInfoCard(
                            'Account Role',
                            (state is ProfileLoaded
                                ? state.profile.role
                                : (state as ProfileUpdated).profile.role),
                            Icons.badge_outlined,
                          ),
                          _buildInfoCard(
                            'Phone Number',
                            (state is ProfileLoaded
                                ? state.profile.phone
                                : (state as ProfileUpdated).profile.phone),
                            Icons.phone_outlined,
                          ),
                          _buildInfoCard(
                            'Mailing Address',
                            (state is ProfileLoaded
                                ? state.profile.address
                                : (state as ProfileUpdated).profile.address),
                            Icons.location_on_outlined,
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: () {
                                final profile = state is ProfileLoaded
                                    ? state.profile
                                    : (state as ProfileUpdated).profile;
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.editProfile,
                                  arguments: profile,
                                );
                              },
                              child: const Text('Edit Profile Information'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  const SliverToBoxAdapter(child: SizedBox()),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: const Color(0xFF6366F1)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (route) => false,
              );
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }
}
