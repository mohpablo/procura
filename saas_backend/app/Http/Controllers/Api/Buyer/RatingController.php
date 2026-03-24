<?php

namespace App\Http\Controllers\Api\Buyer;

use App\Http\Controllers\Controller;
use App\Http\Requests\Ratings\SubmitRatingRequest;
use App\Models\Rating;
use App\Models\Order;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class RatingController extends Controller
{
    /**
     * Submit rating for completed order
     */
    public function store(SubmitRatingRequest $request): JsonResponse
    {
        try {
            $order = Order::findOrFail($request->order_id);

            // Check if buyer owns this order
            if ($order->buyer_id !== $request->user()->id) {
                return response()->json([
                    'success' => false,
                    'message' => 'Unauthorized',
                ], 403);
            }

            // Check if order is delivered
            if ($order->status !== 'delivered') {
                return response()->json([
                    'success' => false,
                    'message' => 'Can only rate delivered orders',
                ], 422);
            }

            // Check if already rated
            $existingRating = Rating::where('order_id', $order->id)->first();
            if ($existingRating) {
                return response()->json([
                    'success' => false,
                    'message' => 'Order already rated',
                ], 422);
            }

            $rating = Rating::create([
                'order_id' => $request->order_id,
                'buyer_id' => $request->user()->id,
                'supplier_id' => $order->supplier_id,
                'rating' => $request->rating,
                'comment' => $request->comment,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Rating submitted successfully',
                'data' => $rating,
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to submit rating: ' . $e->getMessage(),
            ], 400);
        }
    }

    /**
     * Get orders available for rating
     */
    public function available(Request $request): JsonResponse
    {
        try {
            $orders = Order::where('buyer_id', $request->user()->id)
                ->where('status', 'delivered')
                ->whereDoesntHave('rating')
                ->with('supplier', 'orderItems.product')
                ->orderBy('updated_at', 'desc')
                ->paginate(10);

            return response()->json([
                'success' => true,
                'data' => $orders,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to fetch available orders: ' . $e->getMessage(),
            ], 400);
        }
    }
}
