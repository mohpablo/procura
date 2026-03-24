<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\Auth\LoginRequest;
use App\Http\Requests\Auth\RegisterRequest;
use App\Models\User;
use App\Models\Company;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
    /**
     * Register a new user (buyer or supplier)
     */
    public function register(RegisterRequest $request): JsonResponse
    {
        \Illuminate\Support\Facades\DB::beginTransaction();
        try {
            $user = User::create([
                'name' => $request->name,
                'email' => $request->email,
                'password' => Hash::make($request->password),
                'phone' => $request->phone,
                'role' => $request->role,
                'address' => $request->company_address ?? '',
            ]);

            $company = Company::create([
                'name' => $request->company_name,
                'type' => $request->company_type,
                'is_verified' => false,
                'address' => $request->company_address,
                'phone' => $request->phone,
                'email' => $request->email,
            ]);

            $user->update(['company_id' => $company->id]);

            \Illuminate\Support\Facades\DB::commit();

            $token = $user->createToken('mobile_app')->plainTextToken;

            return response()->json([
                'success' => true,
                'message' => 'User registered successfully',
                'data' => [
                    'user' => $user->load('company'),
                    'token' => $token,
                    'token_type' => 'Bearer',
                ],
            ], 201);
        } catch (\Exception $e) {
            \Illuminate\Support\Facades\DB::rollBack();
            return response()->json([
                'success' => false,
                'message' => 'Registration failed: ' . $e->getMessage(),
            ], 400);
        }
    }

    /**
     * Login user
     */
    public function login(LoginRequest $request): JsonResponse
    {
        try {
            $user = User::where('email', $request->email)->first();

            if (!$user || !Hash::check($request->password, $user->password)) {
                return response()->json([
                    'success' => false,
                    'message' => 'Invalid email or password',
                ], 401);
            }

            // Revoke previous tokens
            $user->tokens()->delete();

            $token = $user->createToken($request->device_name ?? 'mobile')->plainTextToken;

            return response()->json([
                'success' => true,
                'message' => 'Login successful',
                'data' => [
                    'user' => $user->load('company'),
                    'token' => $token,
                    'token_type' => 'Bearer',
                ],
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Login failed: ' . $e->getMessage(),
            ], 400);
        }
    }

    /**
     * Logout user
     */
    public function logout(Request $request): JsonResponse
    {
        $request->user()->currentAccessToken()->delete();

        return response()->json([
            'success' => true,
            'message' => 'Logged out successfully',
        ]);
    }

    /**
     * Get authenticated user
     */
    public function me(Request $request): JsonResponse
    {
        return response()->json([
            'success' => true,
            'data' => $request->user()->load('company'),
        ]);
    }

    /**
     * Refresh token
     */
    public function refreshToken(Request $request): JsonResponse
    {
        $user = $request->user();
        $user->tokens()->delete();
        $token = $user->createToken('mobile_app')->plainTextToken;

        return response()->json([
            'success' => true,
            'message' => 'Token refreshed',
            'data' => [
                'token' => $token,
            ],
        ]);
    }
}
