<?php

namespace App\Http\Requests\Auth;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rules\Password;

class RegisterRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     */
    public function rules(): array
    {
        return [
            'name' => ['required', 'string', 'max:255'],
            'email' => ['required', 'string', 'email', 'max:255', 'unique:users,email'],
            'password' => ['required', 'confirmed', Password::defaults()],
            'role' => ['required', 'in:buyer,supplier'],
            'phone' => ['required', 'string', 'max:20'],
            'company_name' => ['required', 'string', 'max:255'],
            'company_type' => ['required', 'in:buyer,supplier,both'],
            'company_address' => ['required', 'string', 'max:255'],
        ];
    }

    /**
     * Get custom messages for validation rules.
     */
    public function messages(): array
    {
        return [
            'password.confirmed' => 'The password confirmation does not match.',
            'company_name.required_if' => 'Company name is required for suppliers.',
        ];
    }
}
