@extends('layouts.app')

@section('title', 'Supplier Analytics')
@section('header_title', 'Revenue & Performance')

@section('content')
<div class="stats-grid">
    <div class="stat-card">
        <div class="label">Average Order Value</div>
        <div class="value">${{ number_format($stats['avg_order_value'], 2) }}</div>
    </div>
    <div class="stat-card">
        <div class="label">Order Conversion Rate</div>
        <div class="value" style="color: var(--primary);">{{ number_format($stats['conversion_rate'], 1) }}%</div>
    </div>
    <div class="stat-card">
        <div class="label">Return Customer Rate</div>
        <div class="value">{{ number_format($stats['return_customer_rate'], 1) }}%</div>
    </div>
    <div class="stat-card">
        <div class="label">Top Selling Category</div>
        <div class="value" style="font-size: 1.25rem;">{{ $stats['top_category'] }}</div>
    </div>
</div>

<div class="card-container" style="margin-top: 2rem; padding: 2rem; text-align: center;">
    <div style="height: 300px; display: flex; align-items: flex-end; justify-content: space-around; gap: 1rem; border-bottom: 2px solid var(--border); padding-bottom: 1rem;">
        @foreach($stats['trend'] as $data)
            @php $height = ($data['revenue'] / $stats['max_revenue']) * 100; @endphp
            <div style="width: 40px; height: {{ $height > 0 ? $height : 5 }}%; background: var(--primary); border-radius: 4px 4px 0 0;" title="${{ number_format($data['revenue']) }}"></div>
        @endforeach
    </div>
    <div style="display: flex; justify-content: space-around; margin-top: 1rem; color: var(--text-muted); font-size: 0.875rem;">
        @foreach($stats['trend'] as $data)
            <span>{{ $data['month'] }}</span>
        @endforeach
    </div>
    <p style="margin-top: 2rem; font-weight: 600;">Revenue Trend (Last 6 Months)</p>
</div>
@endsection
