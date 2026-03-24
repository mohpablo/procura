<?php

namespace App\Http\Controllers\Api\Buyer;

use App\Http\Controllers\Controller;
use App\Models\Notification;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class NotificationController extends Controller
{
    /**
     * Get all notifications for user
     */
    public function index(Request $request): JsonResponse
    {
        try {
            $page = $request->query('page', 1);
            $perPage = $request->query('per_page', 20);
            $unread = $request->query('unread', false);

            $query = Notification::where('user_id', $request->user()->id);

            if ($unread) {
                $query->whereNull('read_at');
            }

            $notifications = $query->orderBy('created_at', 'desc')
                ->paginate($perPage, ['*'], 'page', $page);

            return response()->json([
                'success' => true,
                'data' => $notifications,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to fetch notifications: ' . $e->getMessage(),
            ], 400);
        }
    }

    /**
     * Mark notification as read
     */
    public function markAsRead(Request $request, Notification $notification): JsonResponse
    {
        try {
            if ($notification->user_id !== $request->user()->id) {
                return response()->json([
                    'success' => false,
                    'message' => 'Unauthorized',
                ], 403);
            }

            $notification->markAsRead();

            return response()->json([
                'success' => true,
                'message' => 'Notification marked as read',
                'data' => $notification,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to mark notification: ' . $e->getMessage(),
            ], 400);
        }
    }

    /**
     * Mark all notifications as read
     */
    public function markAllAsRead(Request $request): JsonResponse
    {
        try {
            Notification::where('user_id', $request->user()->id)
                ->whereNull('read_at')
                ->update(['read_at' => now()]);

            return response()->json([
                'success' => true,
                'message' => 'All notifications marked as read',
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to mark notifications: ' . $e->getMessage(),
            ], 400);
        }
    }

    /**
     * Get unread count
     */
    public function unreadCount(Request $request): JsonResponse
    {
        try {
            $count = Notification::where('user_id', $request->user()->id)
                ->whereNull('read_at')
                ->count();

            return response()->json([
                'success' => true,
                'data' => ['unread_count' => $count],
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to fetch unread count: ' . $e->getMessage(),
            ], 400);
        }
    }
}
