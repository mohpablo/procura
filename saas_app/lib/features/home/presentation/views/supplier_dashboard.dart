import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saas_app/core/routes/app_routes.dart';
import 'package:saas_app/features/auth/domain/entities/user.dart';
import 'package:saas_app/features/home/presentation/cubit/home_cubit.dart';

class SupplierDashboard extends StatefulWidget {
  const SupplierDashboard({super.key, required this.user});

  final User user;
  static const routeName = "/supplier_dashboard";

  @override
  State<SupplierDashboard> createState() => _SupplierDashboardState();
}

class _SupplierDashboardState extends State<SupplierDashboard> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().loadSupplierDashboard();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final stats = state is SupplierDashboardLoaded ? state.stats : null;

          return RefreshIndicator(
            onRefresh: () async => context.read<HomeCubit>().refresh(),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverAppBar(
                  expandedHeight: 220.0,
                  floating: false,
                  pinned: true,
                  elevation: 0,
                  backgroundColor: const Color(0xFF6366F1),
                  flexibleSpace: LayoutBuilder(
                    builder: (context, constraints) {
                      final top = constraints.biggest.height;
                      final isCollapsed =
                          top <=
                          kToolbarHeight +
                              MediaQuery.of(context).padding.top +
                              10;

                      return FlexibleSpaceBar(
                        centerTitle: false,
                        titlePadding: const EdgeInsetsDirectional.only(
                          start: 20,
                          bottom: 16,
                        ),
                        title: AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: isCollapsed ? 1.0 : 0.0,
                          child: const Text(
                            'Supplier Hub',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                        background: Stack(
                          fit: StackFit.expand,
                          children: [
                            // Main Gradient Background
                            Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF4F46E5),
                                    Color(0xFF6366F1),
                                    Color(0xFF818CF8),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                            ),
                            // Decorative Background Element
                            Positioned(
                              right: -50,
                              top: -50,
                              child: Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.05),
                                ),
                              ),
                            ),
                            // Profile Info Section (Fades out)
                            AnimatedOpacity(
                              duration: const Duration(milliseconds: 200),
                              opacity: isCollapsed ? 0.0 : 1.0,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.15),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.2),
                                          width: 2,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.store_rounded,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      widget.user.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Store Manager',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            context,
                            title: 'Revenue',
                            value: stats != null
                                ? '\$${stats.totalRevenue.toStringAsFixed(1)}'
                                : '...',
                            icon: Icons.payments_rounded,
                            color: const Color(0xFF10B981),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            context,
                            title: 'Orders',
                            value: stats != null
                                ? stats.totalOrders.toString()
                                : '...',
                            icon: Icons.shopping_basket_rounded,
                            color: const Color(0xFF6366F1),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            context,
                            title: 'Stock',
                            value: stats != null
                                ? stats.totalProducts.toString()
                                : '...',
                            icon: Icons.inventory_2_rounded,
                            color: const Color(0xFFF59E0B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        Text(
                          'Quick Management',
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 1.4,
                        ),
                    delegate: SliverChildListDelegate([
                      _buildActionCard(
                        context,
                        icon: Icons.add_circle_outline_rounded,
                        title: 'Add Product',
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRoutes.supplierAddProduct,
                        ),
                      ),
                      _buildActionCard(
                        context,
                        icon: Icons.inventory_rounded,
                        title: 'Inventory',
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRoutes.supplierProducts,
                        ),
                      ),
                      _buildActionCard(
                        context,
                        icon: Icons.assignment_rounded,
                        title: 'Orders',
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRoutes.supplierOrders,
                        ),
                      ),
                      _buildActionCard(
                        context,
                        icon: Icons.analytics_rounded,
                        title: 'Analytics',
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRoutes.supplierAnalytics,
                        ),
                      ),
                    ]),
                  ),
                ),
                const SliverPadding(
                  padding: EdgeInsets.only(top: 32, left: 20, right: 20),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      'Recent Sales',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverToBoxAdapter(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Center(
                          child: Text(
                            'No recent sales data',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: const Color(0xFF64748B)),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
