# Mobile App API - Quick Start Guide

## 🚀 Quick Setup

### 1. Environment Setup

```bash
cp .env.example .env
php artisan key:generate
php artisan migrate
```

### 2. Start Development Server

```bash
php artisan serve --host=0.0.0.0 --port=8000
```

## 🧪 Testing Endpoints with cURL

### Register as Buyer

```bash
curl -X POST http://localhost:8000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Doe",
    "email": "john@example.com",
    "password": "Password@123",
    "password_confirmation": "Password@123",
    "role": "buyer",
    "phone": "1234567890"
  }'
```

### Register as Supplier

```bash
curl -X POST http://localhost:8000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Jane Smith",
    "email": "jane@example.com",
    "password": "Password@123",
    "password_confirmation": "Password@123",
    "role": "supplier",
    "phone": "9876543210",
    "company_name": "Tech Supplies Inc",
    "company_type": "supplier",
    "company_address": "123 Tech St"
  }'
```

### Login

```bash
curl -X POST http://localhost:8000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "john@example.com",
    "password": "Password@123",
    "device_name": "iPhone 13"
  }'
```

### Browse Products

```bash
curl -X GET "http://localhost:8000/api/v1/products?search=laptop&sort_by=price_asc" \
  -H "Content-Type: application/json"
```

### Get Authenticated User

```bash
curl -X GET http://localhost:8000/api/v1/auth/me \
  -H "Authorization: Bearer {TOKEN}" \
  -H "Content-Type: application/json"
```

## 📁 File Structure

```
app/
├── Http/
│   ├── Controllers/
│   │   └── Api/
│   │       ├── AuthController.php
│   │       ├── Buyer/
│   │       │   ├── CartController.php
│   │       │   ├── NotificationController.php
│   │       │   ├── OrderController.php
│   │       │   ├── ProfileController.php
│   │       │   ├── ProductController.php
│   │       │   └── RatingController.php
│   │       ├── Supplier/
│   │       │   ├── CompanyController.php
│   │       │   ├── DashboardController.php
│   │       │   ├── OrderController.php
│   │       │   └── ProductController.php
│   │       └── Admin/
│   │           ├── DashboardController.php
│   │           ├── OrderController.php
│   │           ├── ProductController.php
│   │           ├── RatingController.php
│   │           └── SupplierController.php
│   ├── Middleware/
│   │   ├── IsAdmin.php
│   │   ├── IsBuyer.php
│   │   └── IsSupplier.php
│   └── Requests/
│       ├── Auth/
│       ├── Cart/
│       ├── Orders/
│       ├── Products/
│       ├── Ratings/
│       └── Users/
└── Models/
    ├── Category.php
    ├── Company.php
    ├── Document.php
    ├── Notification.php
    ├── Order.php
    ├── OrderItem.php
    ├── Product.php
    ├── Rating.php
    └── User.php
```

## 🔑 Key Concepts

### Cart Management

- Stored in **cache** (Redis recommended for production)
- Expires after 7 days
- Per-user isolated
- Stock validation on add

### Orders

- Created from cart items
- Grouped by supplier automatically
- Stock decremented on checkout
- Can be cancelled if pending

### Notifications

- Real-time ready (use queues for production)
- Mark as read functionality
- Unread count tracking

### File Uploads

- Products: Store in `storage/app/public/products`
- Documents: Store in `storage/app/public/documents/{company_id}`
- Link files: `php artisan storage:link`

## 🛡️ Security Features

1. **Role-Based Access Control (RBAC)**
    - Buyer, Supplier, Admin roles
    - Middleware-based route protection

2. **Auth**
    - Laravel Sanctum tokens
    - Device-specific tokens
    - Token refresh endpoint

3. **Validation**
    - Form Requests for all inputs
    - Email unique checking
    - File type/size validation

4. **Authorization**
    - Users can only access their own data
    - Suppliers can only manage their products/orders
    - Admin-only dashboard

## 📊 Useful Artisan Commands

```bash
# Check all routes
php artisan route:list

# Verify syntax
php artisan tinker

# Clear cache
php artisan cache:clear

# Generate missing assets
php artisan storage:link

# Seed test data
php artisan db:seed
```

## 🔗 Frontend Integration

### Install Flutter SDK

```bash
flutter pub add dio dio_cache_interceptor
```

### Install React Dependencies

```bash
npm install axios zustand
```

## 📝 API Response Examples

### Success Response

```json
{
  "success": true,
  "message": "Operation successful",
  "data": { ... }
}
```

### Error Response

```json
{
    "success": false,
    "message": "Error description"
}
```

### Validation Error

```json
{
    "success": false,
    "message": "Validation failed",
    "errors": {
        "field_name": ["Error message"]
    }
}
```

## 🚨 Common Issues & Solutions

### CORS Issues

Add to config/cors.php:

```php
'paths' => ['api/*', 'sanctum/csrf-cookie'],
```

### 404 on API Routes

- Clear route cache: `php artisan route:clear`
- Verify middleware aliases in `bootstrap/app.php`

### Token Expiration

- Refresh token: `POST /auth/refresh-token`
- Re-login if needed

### Cart Not Persisting

- Check Redis connection
- Verify cache driver in `.env`

## 📚 Additional Resources

- [Laravel Docs](https://laravel.com/docs)
- [Sanctum Auth](https://laravel.com/docs/sanctum)
- [Form Requests](https://laravel.com/docs/requests#form-request-validation)
- [API Documentation](./API_DOCUMENTATION.md)

## 🤝 Support

For API issues:

1. Check logs: `storage/logs/laravel.log`
2. Test endpoint in Postman
3. Verify request headers and format
4. Check authentication token

## 📄 License

Proprietary - B2B SaaS Platform
