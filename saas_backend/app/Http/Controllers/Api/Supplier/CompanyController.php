<?php

namespace App\Http\Controllers\Api\Supplier;

use App\Http\Controllers\Controller;
use App\Http\Requests\Users\UpdateProfileRequest;
use App\Models\Document;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class CompanyController extends Controller
{
    /**
     * Get company profile
     */
    public function show(Request $request): JsonResponse
    {
        try {
            $company = $request->user()->company->load('users', 'ratings');

            return response()->json([
                'success' => true,
                'data' => $company,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to fetch company: ' . $e->getMessage(),
            ], 400);
        }
    }

    /**
     * Update company profile
     */
    public function update(Request $request): JsonResponse
    {
        try {
            $request->validate([
                'name' => ['nullable', 'string', 'max:255'],
                'email' => ['nullable', 'string', 'email'],
                'phone' => ['nullable', 'string', 'max:20'],
                'address' => ['nullable', 'string'],
                'description' => ['nullable', 'string'],
            ]);

            $company = $request->user()->company;
            $company->update($request->only(['name', 'email', 'phone', 'address', 'description']));

            return response()->json([
                'success' => true,
                'message' => 'Company profile updated',
                'data' => $company,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to update company: ' . $e->getMessage(),
            ], 400);
        }
    }

    /**
     * Get company ratings and reviews
     */
    public function ratings(Request $request): JsonResponse
    {
        try {
            $company = $request->user()->company;
            $ratings = $company->ratings()
                ->with('buyer', 'order')
                ->orderBy('created_at', 'desc')
                ->paginate(20);

            $stats = [
                'average_rating' => $company->ratings()->avg('rating') ?? 0,
                'total_ratings' => $company->ratings()->count(),
                'rating_distribution' => [
                    '5' => $company->ratings()->where('rating', 5)->count(),
                    '4' => $company->ratings()->where('rating', 4)->count(),
                    '3' => $company->ratings()->where('rating', 3)->count(),
                    '2' => $company->ratings()->where('rating', 2)->count(),
                    '1' => $company->ratings()->where('rating', 1)->count(),
                ],
            ];

            return response()->json([
                'success' => true,
                'data' => [
                    'stats' => $stats,
                    'ratings' => $ratings,
                ],
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to fetch ratings: ' . $e->getMessage(),
            ], 400);
        }
    }

    /**
     * Upload document for verification
     */
    public function uploadDocument(Request $request): JsonResponse
    {
        try {
            $request->validate([
                'type' => ['required', 'in:business_document,product_template'],
                'file' => ['required', 'file', 'mimes:pdf,doc,docx,xls,xlsx', 'max:5120'],
            ]);

            $company = $request->user()->company;
            $file = $request->file('file');
            $path = $file->store('documents/' . $company->id, 'public');

            $document = Document::create([
                'company_id' => $company->id,
                'type' => $request->type,
                'file_path' => $path,
                'status' => 'pending',
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Document uploaded successfully',
                'data' => $document,
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to upload document: ' . $e->getMessage(),
            ], 400);
        }
    }

    /**
     * Get company documents
     */
    public function documents(Request $request): JsonResponse
    {
        try {
            $company = $request->user()->company;
            $documents = $company->documents()
                ->orderBy('created_at', 'desc')
                ->paginate(20);

            return response()->json([
                'success' => true,
                'data' => $documents,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to fetch documents: ' . $e->getMessage(),
            ], 400);
        }
    }
}
