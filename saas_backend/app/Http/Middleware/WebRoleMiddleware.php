<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class WebRoleMiddleware
{
    /**
     * Handle an incoming request.
     */
    public function handle(Request $request, Closure $next, string $role): Response
    {
        if (!auth()->check()) {
            return redirect('/login');
        }

        if (auth()->user()->role !== $role) {
            if (auth()->user()->role === 'admin') {
                return redirect('/admin/dashboard');
            } elseif (auth()->user()->role === 'supplier') {
                return redirect('/supplier/dashboard');
            }
            
            \Illuminate\Support\Facades\Auth::logout();
            return redirect('/login')->withErrors(['email' => 'Unauthorized access.']);
        }

        return $next($request);
    }
}
