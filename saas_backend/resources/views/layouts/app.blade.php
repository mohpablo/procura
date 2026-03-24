<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>@yield('title') - B2B Marketplace</title>
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Custom Dashboard CSS -->
    <link rel="stylesheet" href="{{ asset('css/dashboard.css') }}">
    @yield('styles')
</head>
<body>
    @auth
    <div class="sidebar">
        <div class="sidebar-header">
            <i class="fas fa-microchip"></i>
            <span>B2B Market</span>
        </div>
        <nav class="nav-links">
            @if(auth()->user()->role === 'admin')
                <a href="{{ route('admin.dashboard') }}" class="nav-item {{ request()->routeIs('admin.dashboard') ? 'active' : '' }}">
                    <i class="fas fa-th-large"></i> Dashboard
                </a>
                <a href="{{ route('admin.suppliers') }}" class="nav-item {{ request()->routeIs('admin.suppliers') ? 'active' : '' }}">
                    <i class="fas fa-truck"></i> Suppliers
                </a>
                <a href="{{ route('admin.orders') }}" class="nav-item {{ request()->routeIs('admin.orders') ? 'active' : '' }}">
                    <i class="fas fa-shopping-cart"></i> Orders
                </a>
                <a href="{{ route('admin.analytics') }}" class="nav-item {{ request()->routeIs('admin.analytics') ? 'active' : '' }}">
                    <i class="fas fa-chart-line"></i> Analytics
                </a>
            @elseif(auth()->user()->role === 'supplier')
                <a href="{{ route('supplier.dashboard') }}" class="nav-item {{ request()->routeIs('supplier.dashboard') ? 'active' : '' }}">
                    <i class="fas fa-th-large"></i> Dashboard
                </a>
                <a href="{{ route('supplier.products') }}" class="nav-item {{ request()->routeIs('supplier.products') ? 'active' : '' }}">
                    <i class="fas fa-box"></i> Products
                </a>
                <a href="{{ route('supplier.orders') }}" class="nav-item {{ request()->routeIs('supplier.orders') ? 'active' : '' }}">
                    <i class="fas fa-shopping-cart"></i> Orders
                </a>
                <a href="{{ route('supplier.analytics') }}" class="nav-item {{ request()->routeIs('supplier.analytics') ? 'active' : '' }}">
                    <i class="fas fa-chart-line"></i> Revenue
                </a>
            @endif
            
            <form action="{{ route('logout') }}" method="POST" style="margin-top: 2rem; padding: 0 1rem;">
                @csrf
                <button type="submit" class="nav-item" style="width: 100%; border: none; background: none; cursor: pointer;">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </button>
            </form>
        </nav>
    </div>
    @endauth

    <div class="main-content" style="{{ !auth()->check() ? 'margin-left: 0;' : '' }}">
        <header class="top-bar">
            <div>
                <h1 style="font-size: 1.25rem; font-weight: 700;">@yield('header_title', 'Dashboard')</h1>
                <p style="font-size: 0.875rem; color: var(--text-muted);">Welcome back, {{ auth()->user()->name ?? 'Guest' }}</p>
            </div>
            <div style="display: flex; align-items: center; gap: 1rem;">
                <div style="text-align: right;">
                    <div style="font-weight: 600;">{{ auth()->user()->name ?? '' }}</div>
                    <div style="font-size: 0.75rem; color: var(--text-muted); text-transform: capitalize;">{{ auth()->user()->role ?? '' }} Panel</div>
                </div>
                <div style="width: 40px; height: 40px; background: var(--primary); color: #fff; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 700;">
                    {{ substr(auth()->user()->name ?? 'G', 0, 1) }}
                </div>
            </div>
        </header>

        <main>
            @if(session('success'))
                <div style="padding: 1rem; background: #dcfce7; color: #166534; border-radius: 0.5rem; margin-bottom: 1.5rem; border: 1px solid #bbf7d0;">
                    {{ session('success') }}
                </div>
            @endif

            @if($errors->any())
                <div style="padding: 1rem; background: #fee2e2; color: #991b1b; border-radius: 0.5rem; margin-bottom: 1.5rem; border: 1px solid #fecaca;">
                    <ul style="margin: 0; padding-left: 1.25rem;">
                        @foreach($errors->all() as $error)
                            <li>{{ $error }}</li>
                        @endforeach
                    </ul>
                </div>
            @endif

            @yield('content')
        </main>
    </div>

    @yield('scripts')
</body>
</html>
