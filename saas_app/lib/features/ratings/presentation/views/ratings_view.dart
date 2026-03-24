import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/rating_cubit.dart';
import '../cubit/rating_state.dart';

class RatingsView extends StatefulWidget {
  static const String routeName = '/buyer/ratings';

  const RatingsView({super.key});

  @override
  State<RatingsView> createState() => _RatingsViewState();
}

class _RatingsViewState extends State<RatingsView> {
  @override
  void initState() {
    super.initState();
    context.read<RatingCubit>().loadAvailableRatings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rate Orders'), elevation: 0),
      body: BlocConsumer<RatingCubit, RatingState>(
        listener: (context, state) {
          if (state is RatingSubmitted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Rating submitted successfully')),
            );
            context.read<RatingCubit>().loadAvailableRatings();
          }
        },
        builder: (context, state) {
          if (state is RatingLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is RatingError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<RatingCubit>().loadAvailableRatings();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is RatingLoaded) {
            if (state.ratings.isEmpty) {
              return const Center(
                child: Text('No orders available for rating'),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.ratings.length,
              itemBuilder: (context, index) {
                final rating = state.ratings[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text('Order #${rating.orderId}'),
                    subtitle: Text('Supplier ID: ${rating.supplierId}'),
                    trailing: ElevatedButton(
                      onPressed: () {
                        _showRatingDialog(context, rating.orderId);
                      },
                      child: const Text('Rate'),
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  void _showRatingDialog(BuildContext context, int orderId) {
    double rating = 5.0;
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Rate Order'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Rating:'),
            Slider(
              value: rating,
              min: 1,
              max: 5,
              divisions: 4,
              label: rating.toString(),
              onChanged: (value) {
                rating = value;
              },
            ),
            TextField(
              controller: commentController,
              decoration: const InputDecoration(
                labelText: 'Comment (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<RatingCubit>().submitRating(
                orderId: orderId,
                rating: rating,
                comment: commentController.text.isEmpty
                    ? null
                    : commentController.text,
              );
              Navigator.pop(dialogContext);
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
