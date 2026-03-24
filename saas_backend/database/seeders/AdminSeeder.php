<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class AdminSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        \App\Models\User::updateOrCreate(
            ['email' => 'admin@procurify.com'],
            [
                'name' => 'Platform Admin',
                'password' => \Illuminate\Support\Facades\Hash::make('admin123456'),
                'role' => 'admin',
                'phone' => '123456789',
                'address' => 'HQ Cairo',
            ]
        );
    }
}
