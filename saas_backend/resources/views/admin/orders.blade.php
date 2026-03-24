@extends('layouts.app')

@section('title', 'Admin - Platform Orders')
@section('header_title', 'All Platform Orders')

@section('content')
<div class="card-container">
    <div class="card-header">
        <h3 style="margin: 0; font-size: 1.125rem; font-weight: 600;">Order Monitoring</h3>
    </div>
    <table class="premium-table">
        <thead>
            <tr>
                <th>Order ID</th>
                <th>Supplier</th>
                <th>Buyer</th>
                <th>Amount</th>
                <th>Status</th>
                <th>Date</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            @forelse($orders as $order)
                <tr>
                    <td>#{{ $order->id }}</td>
                    <td>
                        <div style="font-weight: 600;">{{ $order->supplier->name }}</div>
                        <div style="font-size: 0.75rem; color: var(--text-muted);">ID: #{{ $order->supplier_id }}</div>
                    </td>
                    <td>
                        <div style="font-weight: 600;">{{ $order->buyer->name }}</div>
                        <div style="font-size: 0.75rem; color: var(--text-muted);">ID: #{{ $order->buyer_id }}</div>
                    </td>
                    <td style="font-weight: 600;">${{ number_format($order->total_amount, 2) }}</td>
                    <td>
                        <span style="padding: 0.25rem 0.5rem; border-radius: 9999px; font-size: 0.75rem; font-weight: 600; 
                            @if($order->status == 'delivered') background: #dcfce7; color: #166534;
                            @elseif($order->status == 'pending') background: #fef9c3; color: #854d0e;
                            @elseif($order->status == 'ready_for_delivery') background: #dbeafe; color: #1e40af;
                            @else background: #f1f5f9; color: #475569; @endif">
                            {{ ucfirst($order->status) }}
                        </span>
                    </td>
                    <td>{{ $order->created_at->format('M d, Y') }}</td>
                    <td>
                        <form action="{{ route('admin.orders.update-status', $order->id) }}" method="POST">
                            @csrf
                            <select name="status" onchange="this.form.submit()" class="form-input" style="padding: 0.25rem; font-size: 0.75rem; width: auto;">
                                <option value="pending" {{ $order->status == 'pending' ? 'selected' : '' }} disabled>Pending</option>
                                <option value="confirmed" {{ $order->status == 'confirmed' ? 'selected' : '' }} disabled>Confirmed</option>
                                <option value="preparing" {{ $order->status == 'preparing' ? 'selected' : '' }} disabled>Preparing</option>
                                <option value="ready_for_delivery" {{ $order->status == 'ready_for_delivery' ? 'selected' : '' }}>Ready for Delivery</option>
                                <option value="scheduled" {{ $order->status == 'scheduled' ? 'selected' : '' }}>Scheduled</option>
                                <option value="delivered" {{ $order->status == 'delivered' ? 'selected' : '' }}>Delivered</option>
                                <option value="cancelled" {{ $order->status == 'cancelled' ? 'selected' : '' }}>Cancelled</option>
                            </select>
                        </form>
                    </td>
                </tr>
            @empty
                <tr>
                    <td colspan="7" style="text-align: center; padding: 2rem; color: var(--text-muted);">No orders found.</td>
                </tr>
            @endforelse
        </tbody>
    </table>
    <div style="padding: 1rem; border-top: 1px solid var(--border);">
        {{ $orders->links() }}
    </div>
</div>
@endsection
