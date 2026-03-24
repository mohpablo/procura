@extends('layouts.app')

@section('title', 'Admin - Supplier Management')
@section('header_title', 'Supplier Management')

@section('content')
<div class="card-container">
    <div class="card-header">
        <h3 style="margin: 0; font-size: 1.125rem; font-weight: 600;">All Suppliers</h3>
    </div>
    <table class="premium-table">
        <thead>
            <tr>
                <th>Company</th>
                <th>Type</th>
                <th>Phone</th>
                <th>Status</th>
                <th>Verification</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            @forelse($suppliers as $supplier)
                <tr>
                    <td>
                        <div style="font-weight: 600;">{{ $supplier->name }}</div>
                        <div style="font-size: 0.75rem; color: var(--text-muted);">{{ $supplier->email }}</div>
                    </td>
                    <td style="text-transform: capitalize;">{{ $supplier->type }}</td>
                    <td>{{ $supplier->phone }}</td>
                    <td>
                        <span style="padding: 0.25rem 0.5rem; border-radius: 9999px; font-size: 0.75rem; font-weight: 600; 
                            @if($supplier->is_verified) background: #dcfce7; color: #166534;
                            @else background: #fee2e2; color: #991b1b; @endif">
                            {{ $supplier->is_verified ? 'Verified' : 'Pending' }}
                        </span>
                    </td>
                    <td>
                        <a href="#" style="font-size: 0.875rem; color: var(--primary); text-decoration: none;">Review Docs</a>
                    </td>
                    <td>
                        <div style="display: flex; gap: 0.5rem;">
                            @if(!$supplier->is_verified)
                                <form action="{{ route('admin.suppliers.verify', $supplier->id) }}" method="POST">
                                    @csrf
                                    <button type="submit" class="btn btn-primary" style="padding: 0.4rem 0.75rem; font-size: 0.75rem;">Verify</button>
                                </form>
                            @endif
                            <form action="{{ route('admin.suppliers.suspend', $supplier->id) }}" method="POST">
                                @csrf
                                <button type="submit" class="btn" style="padding: 0.4rem 0.75rem; font-size: 0.75rem; background: var(--danger); color: #fff;">Suspend</button>
                            </form>
                        </div>
                    </td>
                </tr>
            @empty
                <tr>
                    <td colspan="6" style="text-align: center; padding: 2rem; color: var(--text-muted);">No suppliers found.</td>
                </tr>
            @endforelse
        </tbody>
    </table>
    <div style="padding: 1rem; border-top: 1px solid var(--border);">
        {{ $suppliers->links() }}
    </div>
</div>
@endsection
