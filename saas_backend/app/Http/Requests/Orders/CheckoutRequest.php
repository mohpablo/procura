<?php

namespace App\Http\Requests\Orders;

use Illuminate\Foundation\Http\FormRequest;

class CheckoutRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return auth()->check() && auth()->user()->role === 'buyer';
    }

    /**
     * Get the validation rules that apply to the request.
     */
    public function rules(): array
    {
        return [
            'cart_items' => ['required', 'array', 'min:1'],
            'cart_items.*.product_id' => ['required', 'integer', 'exists:products,id'],
            'cart_items.*.quantity' => ['required', 'integer', 'min:1'],
            'payment_method' => ['required', 'in:credit_card,debit_card,wallet'],
        ];
    }
}
