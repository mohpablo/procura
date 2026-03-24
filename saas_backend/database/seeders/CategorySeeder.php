<?php

namespace Database\Seeders;

use App\Models\Category;
use Illuminate\Database\Seeder;

class CategorySeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $categories = [
            ['name' => 'Electronics', 'description' => 'Electronic devices and gadgets'],
            ['name' => 'Clothing', 'description' => 'Apparel and fashion items'],
            ['name' => 'Food & Beverages', 'description' => 'Food products and drinks'],
            ['name' => 'Furniture', 'description' => 'Furniture and home decor'],
            ['name' => 'Machinery', 'description' => 'Industrial machinery and equipment'],
            ['name' => 'Textiles', 'description' => 'Fabric and textile materials'],
            ['name' => 'Chemicals', 'description' => 'Chemical products and compounds'],
            ['name' => 'Packaging', 'description' => 'Packaging materials and supplies'],
        ];

        foreach ($categories as $category) {
            Category::create($category);
        }
    }
}
