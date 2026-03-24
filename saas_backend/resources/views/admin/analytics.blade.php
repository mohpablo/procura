@extends('layouts.app')

@section('title', 'Admin Analytics')
@section('header_title', 'Platform Intelligence')

@section('content')
<div class="stats-grid">
    <div class="stat-card">
        <div class="label">Active Suppliers</div>
        <div class="value">{{ number_format($stats['active_suppliers']) }}</div>
    </div>
    <div class="stat-card">
        <div class="label">New Registrations (MoM)</div>
        <div class="value" style="color: {{ $stats['registration_growth'] >= 0 ? 'var(--success)' : 'var(--error)' }};">
            {{ $stats['registration_growth'] >= 0 ? '+' : '' }}{{ number_format($stats['registration_growth'], 1) }}%
        </div>
    </div>
    <div class="stat-card">
        <div class="label">Total GMV</div>
        <div class="value" style="color: var(--primary);">${{ number_format($stats['total_gmv'], 2) }}</div>
    </div>
    <div class="stat-card">
        <div class="label">Avg Delivery Time</div>
        <div class="value">{{ number_format($stats['avg_delivery_time'], 1) }} Days</div>
    </div>
</div>

<div class="stats-grid" style="margin-top: 2rem;">
    <div class="card-container" style="padding: 1.5rem;">
        <h4 style="margin: 0 0 1rem 0;">Sector Distribution (By Products)</h4>
        <div style="display: flex; flex-direction: column; gap: 0.75rem;">
            @php $colors = ['var(--primary)', 'var(--success)', 'var(--warning)']; @endphp
            @forelse($stats['sectors'] as $index => $sector)
                @php $percentage = ($sector->count / $stats['total_products']) * 100; @endphp
                <div>
                    <div style="display: flex; justify-content: space-between; font-size: 0.875rem; margin-bottom: 0.25rem;">
                        <span>{{ $sector->name }}</span><span>{{ number_format($percentage, 1) }}%</span>
                    </div>
                    <div style="height: 8px; background: #f1f5f9; border-radius: 4px;">
                        <div style="width: {{ $percentage }}%; height: 100%; background: {{ $colors[$index % count($colors)] }}; border-radius: 4px;"></div>
                    </div>
                </div>
            @empty
                <div style="text-align: center; color: var(--text-muted); font-size: 0.875rem;">No sectors found</div>
            @endforelse
        </div>
    </div>
    
    <div class="card-container" style="padding: 1.5rem;">
        <h4 style="margin: 0 0 1rem 0;">System Happiness</h4>
        <div style="text-align: center; padding: 1rem;">
            <div style="font-size: 3rem; color: {{ $stats['avg_rating'] >= 4 ? 'var(--success)' : ($stats['avg_rating'] >= 3 ? 'var(--warning)' : 'var(--error)') }};"><i class="fas fa-smile"></i></div>
            <div style="font-size: 1.5rem; font-weight: 700; margin-top: 0.5rem;">{{ number_format($stats['avg_rating'], 1) }}/5.0</div>
            <p style="color: var(--text-muted); font-size: 0.875rem;">Avg Supplier Rating</p>
        </div>
    </div>
</div>
@endsection
