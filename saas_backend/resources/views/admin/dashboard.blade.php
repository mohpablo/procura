@extends('layouts.app')

@section('title', 'Admin Dashboard')
@section('header_title', 'Platform Overview')

@section('content')
<div class="stats-grid">
    <div class="stat-card">
        <div class="label">Total Suppliers</div>
        <div class="value">{{ $stats['total_suppliers'] }}</div>
    </div>
    <div class="stat-card">
        <div class="label">Total Buyers</div>
        <div class="value">{{ $stats['total_buyers'] }}</div>
    </div>
    <div class="stat-card">
        <div class="label">Global Orders</div>
        <div class="value">{{ $stats['total_orders'] }}</div>
    </div>
    <div class="stat-card">
        <div class="label">Total Revenue</div>
        <div class="value" style="color: var(--success);">${{ number_format($stats['total_revenue'], 2) }}</div>
    </div>
</div>

<div class="card-container">
    <div class="card-header">
        <h3 style="margin: 0; font-size: 1.125rem; font-weight: 600;">Recent Platform Activity</h3>
        <a href="{{ route('admin.orders') }}" class="btn btn-primary" style="font-size: 0.875rem;">Monitor Orders</a>
    </div>
    <table class="premium-table">
        <thead>
            <tr>
                <th>Order ID</th>
                <th>Supplier</th>
                <th>Buyer</th>
                <th>Amount</th>
                <th>Status</th>
            </tr>
        </thead>
        <tbody>
            @forelse($recentOrders as $order)
                <tr>
                    <td>#{{ $order->id }}</td>
                    <td>{{ $order->supplier->name }}</td>
                    <td>{{ $order->buyer->name }}</td>
                    <td>${{ number_format($order->total_amount, 2) }}</td>
                    <td>
                        <span style="padding: 0.25rem 0.5rem; border-radius: 9999px; font-size: 0.75rem; font-weight: 600; 
                            @if($order->status == 'delivered') background: #dcfce7; color: #166534;
                            @elseif($order->status == 'pending') background: #fef9c3; color: #854d0e;
                            @else background: #f1f5f9; color: #475569; @endif">
                            {{ ucfirst($order->status) }}
                        </span>
                    </td>
                </tr>
            @empty
                <tr>
                    <td colspan="5" style="text-align: center; padding: 2rem; color: var(--text-muted);">No recent activity.</td>
                </tr>
            @endforelse
        </tbody>
    </table>
</div>
@endsection
