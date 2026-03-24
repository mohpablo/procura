import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:saas_app/core/routes/app_routes.dart';
import 'package:saas_app/features/auth/domain/entities/user.dart';
import 'package:saas_app/features/home/domain/entities/recent_activity.dart';
import 'package:saas_app/features/home/presentation/cubit/home_cubit.dart';

class BuyerDashboard extends StatefulWidget {
  final User user;
  const BuyerDashboard({super.key, required this.user});

  @override
  State<BuyerDashboard> createState() => _BuyerDashboardState();
}

class _BuyerDashboardState extends State<BuyerDashboard>
    with TickerProviderStateMixin {
  late AnimationController _listController;

  @override
  void initState() {
    super.initState();
    _listController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    context.read<HomeCubit>().loadBuyerDashboard();
  }

  @override
  void dispose() {
    _listController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: RefreshIndicator(
        onRefresh: () async => context.read<HomeCubit>().loadBuyerDashboard(),
        child: BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {
            if (state is BuyerDashboardLoaded) {
              _listController.forward(from: 0);
            }
          },
          builder: (context, state) {
            if (state is HomeError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      color: Colors.redAccent,
                      size: 60,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<HomeCubit>().loadBuyerDashboard(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F46E5),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              );
            }
            return CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                _buildSliverAppBar(context, state),
                _buildQuickActions(context),
                _buildRecentActivityHeader(context),
                _buildActivityList(context, state),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, HomeState state) {
    return SliverAppBar(
      expandedHeight: 280.0,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: const Color(0xFF4F46E5),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Positioned(
              right: -50,
              top: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Welcome back, ${widget.user.name}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (state is BuyerDashboardLoaded)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          _buildStatCard(
                            'Active Orders',
                            state.stats.activeOrders.toString(),
                            Icons.local_shipping_outlined,
                          ),
                          const SizedBox(width: 12),
                          _buildStatCard(
                            'Total Spent',
                            '\$${state.stats.totalRevenue.toStringAsFixed(0)}',
                            Icons.account_balance_wallet_outlined,
                          ),
                          const SizedBox(width: 12),
                          _buildStatCard(
                            'Saved Items',
                            state.stats.savedItems.toString(),
                            Icons.favorite_border_rounded,
                          ),
                        ],
                      ),
                    )
                  else
                    _buildShimmerHeader(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 11,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(20),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildGlassAction(
                    context,
                    Icons.search_rounded,
                    'Browse',
                    const Color(0xFF6366F1),
                    AppRoutes.products,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildGlassAction(
                    context,
                    Icons.shopping_cart_outlined,
                    'Cart',
                    const Color(0xFF10B981),
                    AppRoutes.cart,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildGlassAction(
                    context,
                    Icons.receipt_long_rounded,
                    'Orders',
                    const Color(0xFFF59E0B),
                    AppRoutes.orders,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildGlassAction(
                    context,
                    Icons.person_outline_rounded,
                    'Profile',
                    const Color(0xFF64748B),
                    AppRoutes.profile,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassAction(
    BuildContext context,
    IconData icon,
    String title,
    Color color,
    String route,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: InkWell(
            onTap: () => Navigator.pushNamed(context, route),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 28),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: Color(0xFF334155),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivityHeader(BuildContext context) {
    return const SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      sliver: SliverToBoxAdapter(
        child: Text(
          'Recent Activity',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1E293B),
          ),
        ),
      ),
    );
  }

  Widget _buildActivityList(BuildContext context, HomeState state) {
    if (state is HomeLoading) {
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => _buildShimmerItem(),
            childCount: 3,
          ),
        ),
      );
    }

    if (state is BuyerDashboardLoaded) {
      if (state.stats.recentActivities.isEmpty) {
        return const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(40),
            child: Center(child: Text('No recent activity')),
          ),
        );
      }

      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final activity = state.stats.recentActivities[index];
            return AnimatedBuilder(
              animation: _listController,
              builder: (context, child) {
                final animation = CurvedAnimation(
                  parent: _listController,
                  curve: Interval(
                    (index / 5).clamp(0, 1),
                    1,
                    curve: Curves.easeOut,
                  ),
                );
                return Opacity(
                  opacity: animation.value,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - animation.value)),
                    child: child,
                  ),
                );
              },
              child: _buildActivityTile(activity),
            );
          }, childCount: state.stats.recentActivities.length),
        ),
      );
    }

    return const SliverToBoxAdapter(child: SizedBox.shrink());
  }

  Widget _buildShimmerItem() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade200,
        highlightColor: Colors.grey.shade100,
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 100, height: 12, color: Colors.white),
                  const SizedBox(height: 8),
                  Container(width: 150, height: 10, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerHeader() {
    return Shimmer.fromColors(
      baseColor: Colors.white.withValues(alpha: 0.1),
      highlightColor: Colors.white.withValues(alpha: 0.2),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            _buildStatCard('Loading', '...', Icons.hourglass_empty),
            const SizedBox(width: 12),
            _buildStatCard('Loading', '...', Icons.hourglass_empty),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityTile(RecentActivity activity) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
              color: activity.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(activity.icon, size: 20, color: activity.color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
                Text(
                  activity.description,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Text(
            _formatDateTime(activity.dateTime),
            style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return DateFormat('MMM d').format(dateTime);
    }
  }
}
