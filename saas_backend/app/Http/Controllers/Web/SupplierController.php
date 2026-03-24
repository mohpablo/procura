<?php

namespace App\Http\Controllers\Web;

use App\Http\Controllers\Controller;
use App\Models\Product;
use App\Models\Order;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class SupplierController extends Controller
{
    public function dashboard()
    {
        $supplierId = auth()->user()->company_id;
        
        $stats = [
            'total_products' => Product::where('supplier_id', $supplierId)->count(),
            'total_orders' => Order::where('supplier_id', $supplierId)->count(),
            'pending_orders' => Order::where('supplier_id', $supplierId)->where('status', 'pending')->count(),
            'total_revenue' => Order::where('supplier_id', $supplierId)->where('status', 'delivered')->sum('total_amount'),
        ];

        $recentOrders = Order::with('buyer')
            ->where('supplier_id', $supplierId)
            ->latest()
            ->take(5)
            ->get();

        return view('supplier.dashboard', compact('stats', 'recentOrders'));
    }

    public function products()
    {
        $products = Product::where('supplier_id', auth()->user()->company_id)
            ->with('category')
            ->paginate(10);
            
        return view('supplier.products', compact('products'));
    }

    public function orders()
    {
        $orders = Order::where('supplier_id', auth()->user()->company_id)
            ->with('buyer')
            ->latest()
            ->paginate(10);
            
        return view('supplier.orders', compact('orders'));
    }

    public function updateStatus(Order $order, Request $request)
    {
        $request->validate(['status' => 'required|string']);
        
        if ($order->supplier_id !== auth()->user()->company_id) {
            abort(403);
        }

        $order->update(['status' => $request->status]);
        return back()->with('success', 'Order status updated to ' . $request->status);
    }

    public function analytics()
    {
        $supplierId = auth()->user()->company_id;
        
        $totalRevenue = Order::where('supplier_id', $supplierId)->where('status', 'delivered')->sum('total_amount');
        $totalOrders = Order::where('supplier_id', $supplierId)->count();
        $avgOrderValue = $totalOrders > 0 ? $totalRevenue / $totalOrders : 0;
        
        $deliveredCount = Order::where('supplier_id', $supplierId)->where('status', 'delivered')->count();
        $conversionRate = $totalOrders > 0 ? ($deliveredCount / $totalOrders) * 100 : 0;

        $uniqueCustomers = Order::where('supplier_id', $supplierId)->distinct('buyer_id')->count('buyer_id');
        $repeatCustomersQuery = DB::table('orders')
            ->select('buyer_id')
            ->where('supplier_id', $supplierId)
            ->groupBy('buyer_id')
            ->havingRaw('COUNT(*) > 1')
            ->get();
        $repeatCustomers = $repeatCustomersQuery->count();
        
        $returnCustomerRate = $uniqueCustomers > 0 ? ($repeatCustomers / $uniqueCustomers) * 100 : 0;

        $topCategoryName = 'N/A';
        $topProduct = DB::table('order_items')
            ->join('orders', 'order_items.order_id', '=', 'orders.id')
            ->join('products', 'order_items.product_id', '=', 'products.id')
            ->join('categories', 'products.category_id', '=', 'categories.id')
            ->where('orders.supplier_id', $supplierId)
            ->select('categories.name', DB::raw('SUM(order_items.quantity) as total_sold'))
            ->groupBy('categories.id', 'categories.name')
            ->orderByDesc('total_sold')
            ->first();

        if ($topProduct) {
            $topCategoryName = $topProduct->name;
        }

        $trend = [];
        for ($i = 5; $i >= 0; $i--) {
            $month = now()->subMonths($i);
            $revenue = Order::where('supplier_id', $supplierId)
                ->where('status', 'delivered')
                ->whereYear('created_at', $month->year)
                ->whereMonth('created_at', $month->month)
                ->sum('total_amount');
            $trend[] = [
                'month' => $month->format('M'),
                'revenue' => $revenue
            ];
        }
        $maxRevenue = max(array_column($trend, 'revenue')) ?: 1;

        $stats = [
            'avg_order_value' => $avgOrderValue,
            'conversion_rate' => $conversionRate,
            'return_customer_rate' => $returnCustomerRate,
            'top_category' => $topCategoryName,
            'trend' => $trend,
            'max_revenue' => $maxRevenue
        ];

        return view('supplier.analytics', compact('stats'));
    }
}
