<?php

namespace App\Http\Requests\Products;

use Illuminate\Foundation\Http\FormRequest;

class UpdateProductRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return auth()->check() && auth()->user()->role === 'supplier';
    }

    /**
     * Get the validation rules that apply to the request.
     */
    public function rules(): array
    {
        return [
            'category_id' => ['nullable', 'integer', 'exists:categories,id'],
            'name' => ['nullable', 'string', 'max:255'],
            'unit' => ['nullable', 'string', 'max:50'],
            'price' => ['nullable', 'numeric', 'min:0.01'],
            'min_order_qty' => ['nullable', 'integer', 'min:1'],
            'stock' => ['nullable', 'integer', 'min:0'],
            'description' => ['nullable', 'string'],
            'images' => ['nullable', 'array'],
            'images.*' => ['image', 'mimes:jpeg,png,jpg,gif', 'max:2048'],
        ];
    }
}
