<?php

namespace App\Http\Controllers\Web;

use App\Http\Controllers\Controller;
use App\Models\Company;
use App\Models\Order;
use App\Models\User;
use Illuminate\Http\Request;

class AdminController extends Controller
{
    public function dashboard()
    {
        $stats = [
            'total_suppliers' => Company::where('type', 'supplier')->orWhere('type', 'both')->count(),
            'total_buyers' => User::where('role', 'buyer')->count(),
            'total_orders' => Order::count(),
            'total_revenue' => Order::where('status', 'delivered')->sum('total_amount'),
        ];

        $recentOrders = Order::with(['buyer', 'supplier'])
            ->latest()
            ->take(5)
            ->get();

        return view('admin.dashboard', compact('stats', 'recentOrders'));
    }

    public function suppliers()
    {
        $suppliers = Company::where('type', 'supplier')->orWhere('type', 'both')
            ->latest()
            ->paginate(10);
            
        return view('admin.suppliers', compact('suppliers'));
    }

    public function orders()
    {
        $orders = Order::with(['buyer', 'supplier'])
            ->latest()
            ->paginate(10);
            
        return view('admin.orders', compact('orders'));
    }

    public function updateStatus(\App\Models\Order $order, Request $request)
    {
        $request->validate(['status' => 'required|string']);
        
        $order->update(['status' => $request->status]);

        \App\Models\Notification::create([
            'user_id' => $order->buyer_id,
            'title' => 'Delivery Update',
            'message' => 'Your order #' . $order->id . ' delivery status has been updated to: ' . str_replace('_', ' ', $request->status) . '.',
            'type' => 'delivery',
        ]);

        return back()->with('success', 'Order delivery status updated to ' . $request->status);
    }

    public function verify(Company $company)
    {
        $company->update(['is_verified' => true]);
        return back()->with('success', 'Supplier verified successfully.');
    }

    public function suspend(Company $company)
    {
        // Example logic: actually suspending might involve a status field
        $company->update(['is_verified' => false]);
        return back()->with('success', 'Supplier suspension processed.');
    }

    public function analytics()
    {
        $activeSuppliers = Company::where('type', 'supplier')->orWhere('type', 'both')->where('is_verified', true)->count();
        $totalOrders = Order::count();
        $totalRevenue = Order::where('status', 'delivered')->sum('total_amount');

        $lastMonthSuppliers = Company::whereIn('type', ['supplier', 'both'])
            ->whereYear('created_at', now()->subMonth()->year)
            ->whereMonth('created_at', now()->subMonth()->month)->count();
            
        $thisMonthSuppliers = Company::whereIn('type', ['supplier', 'both'])
            ->whereYear('created_at', now()->year)
            ->whereMonth('created_at', now()->month)->count();
            
        $registrationGrowth = $lastMonthSuppliers > 0 ? (($thisMonthSuppliers - $lastMonthSuppliers) / $lastMonthSuppliers) * 100 : ($thisMonthSuppliers > 0 ? 100 : 0);

        $deliveredOrders = Order::where('status', 'delivered')->get();
        $totalDeliveryDays = 0;
        foreach ($deliveredOrders as $order) {
            if ($order->updated_at && $order->created_at) {
                $totalDeliveryDays += $order->updated_at->diffInDays($order->created_at);
            }
        }
        $avgDeliveryTime = $deliveredOrders->count() > 0 ? $totalDeliveryDays / $deliveredOrders->count() : 0;

        $sectors = \Illuminate\Support\Facades\DB::table('products')
            ->join('categories', 'products.category_id', '=', 'categories.id')
            ->select('categories.name', \Illuminate\Support\Facades\DB::raw('COUNT(products.id) as count'))
            ->groupBy('categories.id', 'categories.name')
            ->orderByDesc('count')
            ->take(3)
            ->get();
            
        $totalProducts = \App\Models\Product::count();
        $avgRating = \App\Models\Rating::avg('rating') ?? 0;

        $stats = [
            'active_suppliers' => $activeSuppliers,
            'total_gmv' => $totalRevenue,
            'registration_growth' => $registrationGrowth,
            'avg_delivery_time' => $avgDeliveryTime,
            'sectors' => $sectors,
            'total_products' => $totalProducts ?: 1,
            'avg_rating' => $avgRating,
        ];

        return view('admin.analytics', compact('stats'));
    }
}
