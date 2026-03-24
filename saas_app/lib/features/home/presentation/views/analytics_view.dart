import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saas_app/features/home/presentation/cubit/home_cubit.dart';

class AnalyticsView extends StatelessWidget {
  static const String routeName = '/supplier/analytics';

  const AnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final stats = state is SupplierDashboardLoaded ? state.stats : null;

          return RefreshIndicator(
            onRefresh: () => context.read<HomeCubit>().loadSupplierDashboard(),
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 120,
                  pinned: true,
                  flexibleSpace: const FlexibleSpaceBar(
                    title: Text(
                      'Business Analytics',
                      style: TextStyle(
                        color: Color(0xFF1E293B),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    centerTitle: false,
                  ),
                  backgroundColor: Colors.white,
                  elevation: 0,
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildMetricCard(
                          title: 'Total Revenue',
                          value: stats != null
                              ? '\$${stats.totalRevenue.toStringAsFixed(2)}'
                              : '\$0.00',
                          trend: stats != null
                              ? '+0.0%'
                              : '...', // Backend doesn't provide trend yet
                          trendColor: Colors.green,
                        ),
                        const SizedBox(height: 16),
                        _buildMetricCard(
                          title: 'Orders Fulfilled',
                          value: stats != null
                              ? stats.totalOrders.toString()
                              : '0',
                          trend: '+0.0%',
                          trendColor: Colors.green,
                        ),
                        const SizedBox(height: 16),
                        _buildMetricCard(
                          title: 'Total Products',
                          value: stats != null
                              ? stats.totalProducts.toString()
                              : '0',
                          trend: '+0.0%',
                          trendColor: Colors.blue,
                        ),
                        const SizedBox(height: 32),
                        Text(
                          'Performance Over Time',
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        AspectRatio(
                          aspectRatio: 1.7,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey.shade100),
                            ),
                            child: const Center(
                              child: Text(
                                'Chart Placeholder',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
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
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String trend,
    required Color trendColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: trendColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              trend,
              style: TextStyle(
                color: trendColor,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
