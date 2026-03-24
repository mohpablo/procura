<?php

namespace App\Http\Controllers\Api\Buyer;

use App\Http\Controllers\Controller;
use App\Http\Requests\Users\UpdateProfileRequest;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ProfileController extends Controller
{
    /**
     * Get user profile
     */
    public function show(Request $request): JsonResponse
    {
        try {
            $user = $request->user()->load('company');

            return response()->json([
                'success' => true,
                'data' => $user,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to fetch profile: ' . $e->getMessage(),
            ], 400);
        }
    }

    /**
     * Update user profile
     */
    public function update(UpdateProfileRequest $request): JsonResponse
    {
        try {
            $user = $request->user();

            $data = $request->only(['name', 'phone', 'address', 'email']);
            $user->update($data);

            return response()->json([
                'success' => true,
                'message' => 'Profile updated successfully',
                'data' => $user->fresh()->load('company'),
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to update profile: ' . $e->getMessage(),
            ], 400);
        }
    }

    /**
     * Get buyer statistics
     */
    public function statistics(Request $request): JsonResponse
    {
        try {
            $user = $request->user();
            $totalOrders = $user->orders()->count();
            $totalSpent = $user->orders()->sum('total_amount');
            
            $stats = [
                'total_orders' => $totalOrders,
                'pending_orders' => $user->orders()->where('status', 'pending')->count(),
                'completed_orders' => $user->orders()->where('status', 'delivered')->count(),
                'cancelled_orders' => $user->orders()->where('status', 'cancelled')->count(),
                'total_spent' => (float) $totalSpent,
                'total_revenue' => (float) $totalSpent, // Alias for model
                'average_order_value' => $totalOrders > 0 ? (float) ($totalSpent / $totalOrders) : 0.0,
                'active_orders' => $user->orders()->whereIn('status', ['pending', 'confirmed', 'preparing', 'ready_for_delivery', 'scheduled'])->count(),
                'saved_items' => 0, // Placeholder
                'average_rating' => (float) ($user->ratings()->avg('rating') ?? 0),
                'ratings_given' => $user->ratings()->count(),
            ];

            return response()->json([
                'success' => true,
                'data' => $stats,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to fetch statistics: ' . $e->getMessage(),
            ], 400);
        }
    }
}
