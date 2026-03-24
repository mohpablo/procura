# B2B SaaS Mobile App - API Documentation

## API Base URL

```
https://your-domain.com/api/v1
```

## Authentication

All endpoints (except public ones) require Bearer Token authentication:

```
Authorization: Bearer {token}
```

---

## 🔐 Authentication Endpoints

### Public Routes (No Authentication Required)

#### Register User

```
POST /auth/register
Content-Type: application/json

{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "Password@123",
  "password_confirmation": "Password@123",
  "role": "buyer", // or "supplier"
  "phone": "1234567890",
  "company_name": "ABC Corp", // Required if role=supplier
  "company_type": "buyer", // Required if role=supplier: buyer|supplier|both
  "company_address": "123 Main St" // Optional
}

Response: 201
{
  "success": true,
  "message": "User registered successfully",
  "data": {
    "user": { ... },
    "token": "token_here"
  }
}
```

#### Login User

```
POST /auth/login
Content-Type: application/json

{
  "email": "john@example.com",
  "password": "Password@123",
  "device_name": "iPhone 13" // Device identifier
}

Response: 200
{
  "success": true,
  "message": "Login successful",
  "data": {
    "user": { ... },
    "token": "token_here"
  }
}
```

---

## 🛒 Public Product Endpoints (No Auth)

#### Get All Products (with filters)

```
GET /products?search=laptop&category_id=1&min_price=100&max_price=5000&sort_by=price_asc&page=1&per_page=20
```

#### Get Product Details

```
GET /products/{id}
```

#### Get Featured Products

```
GET /products/featured
```

#### Get All Categories

```
GET /categories
```

---

## 👤 Authenticated User Endpoints

### Logout & Token Management

```
POST /auth/logout
Response: { "success": true, "message": "Logged out successfully" }

POST /auth/refresh-token
Response: { "success": true, "token": "new_token" }

GET /auth/me
Response: { "success": true, "data": { user object } }
```

---

## 🛍️ BUYER ENDPOINTS

### Profile Management

#### Get Profile

```
GET /buyer/profile
Response: { "success": true, "data": { user object with company } }
```

#### Update Profile

```
PUT /buyer/profile
{
  "name": "Jane Doe",
  "phone": "9876543210",
  "address": "456 New Ave",
  "email": "jane@example.com"
}
```

#### Get Statistics

```
GET /buyer/statistics
Response:
{
  "success": true,
  "data": {
    "total_orders": 10,
    "pending_orders": 2,
    "completed_orders": 8,
    "cancelled_orders": 0,
    "total_spent": 5000.00,
    "average_rating": 4.5,
    "ratings_given": 8
  }
}
```

### Cart Management

#### Get Cart

```
GET /buyer/cart
Response:
{
  "success": true,
  "data": {
    "items": [ ... ],
    "count": 3,
    "total": 1500.00
  }
}
```

#### Add to Cart

```
POST /buyer/cart/add
{
  "product_id": 1,
  "quantity": 5
}
```

#### Update Cart Item

```
PUT /buyer/cart/{product_id}
{ "quantity": 10 }
```

#### Remove from Cart

```
DELETE /buyer/cart/{product_id}
```

#### Clear Cart

```
POST /buyer/cart/clear
```

### Orders

#### Get All Orders

```
GET /buyer/orders?page=1&per_page=15
```

#### Create Order (Checkout)

```
POST /buyer/orders/checkout
{
  "cart_items": [
    { "product_id": 1, "quantity": 5 },
    { "product_id": 2, "quantity": 3 }
  ],
  "payment_method": "credit_card" // credit_card|debit_card|wallet
}
Response: 201
```

#### Get Order Details

```
GET /buyer/orders/{order_id}
```

#### Cancel Order

```
POST /buyer/orders/{order_id}/cancel
```

#### Track Order

```
GET /buyer/orders/{order_id}/track
```

### Ratings

#### Get Available Orders for Rating

```
GET /buyer/ratings/available
```

#### Submit Rating

```
POST /buyer/ratings
{
  "order_id": 1,
  "rating": 5,
  "comment": "Great product and fast delivery!"
}
```

### Notifications

#### Get Notifications

```
GET /buyer/notifications?page=1&per_page=20&unread=false
```

#### Mark as Read

```
PUT /buyer/notifications/{notification_id}/read
```

#### Mark All as Read

```
POST /buyer/notifications/mark-all-read
```

#### Get Unread Count

```
GET /buyer/notifications/unread-count
Response: { "success": true, "data": { "unread_count": 5 } }
```

---

## 🏭 SUPPLIER ENDPOINTS

### Dashboard

#### Get Overview

```
GET /supplier/dashboard/overview
Response:
{
  "success": true,
  "data": {
    "total_products": 50,
    "total_stock": 1000,
    "pending_orders": 5,
    "confirmed_orders": 10,
    "total_orders": 50,
    "completed_orders": 35,
    "total_revenue": 25000.00,
    "average_rating": 4.7,
    "total_ratings": 40,
    "company_verified": true
  }
}
```

#### Get Recent Orders

```
GET /supplier/dashboard/recent-orders
```

#### Get Order Statistics

```
GET /supplier/dashboard/order-stats
```

#### Get Revenue Analytics

```
GET /supplier/dashboard/revenue?period=month // month|year|all
```

### Product Management

#### List Products

```
GET /supplier/products?search=laptop&category_id=1&page=1&per_page=20
```

#### Create Product

```
POST /supplier/products
{
  "category_id": 1,
  "name": "Laptop",
  "unit": "piece",
  "price": 999.99,
  "min_order_qty": 1,
  "stock": 50,
  "description": "High-performance laptop",
  "images": [ file, file ] // Multipart form data
}
```

#### Get Product Details

```
GET /supplier/products/{product_id}
```

#### Update Product

```
PUT /supplier/products/{product_id}
{
  "name": "Updated Laptop",
  "price": 1099.99,
  "stock": 30,
  "images": [ file ] // Optional
}
```

#### Delete Product

```
DELETE /supplier/products/{product_id}
```

#### Bulk Update Stock

```
POST /supplier/products/bulk-update-stock
{
  "products": [
    { "id": 1, "stock": 50 },
    { "id": 2, "stock": 30 },
    { "id": 3, "stock": 0 }
  ]
}
```

### Order Management

#### Get All Orders

```
GET /supplier/orders?status=pending // Filter by status
```

#### Get Order Details

```
GET /supplier/orders/{order_id}
```

#### Confirm/Reject Order

```
POST /supplier/orders/{order_id}/confirm
{
  "status": "confirmed", // or "rejected"
  "rejection_reason": "Out of stock" // Required if rejected
}
```

#### Update Order Status

```
PUT /supplier/orders/{order_id}/status
{
  "status": "preparing" // pending|confirmed|preparing|ready_for_delivery|scheduled|delivered|cancelled
}
```

#### Mark Ready for Delivery

```
POST /supplier/orders/{order_id}/ready-for-delivery
```

#### Get Pending Orders Count

```
GET /supplier/orders/pending/count
```

### Company Management

#### Get Company Profile

```
GET /supplier/company
```

#### Update Company Profile

```
PUT /supplier/company
{
  "name": "Updated Name",
  "email": "new@example.com",
  "phone": "1234567890",
  "address": "New Address",
  "description": "Updated description"
}
```

#### Get Company Ratings

```
GET /supplier/company/ratings
Response:
{
  "success": true,
  "data": {
    "stats": {
      "average_rating": 4.7,
      "total_ratings": 40,
      "rating_distribution": { "5": 30, "4": 8, "3": 2, "2": 0, "1": 0 }
    },
    "ratings": [ { rating objects paginated }... ]
  }
}
```

#### Upload Document

```
POST /supplier/company/documents
{
  "type": "business_document", // business_document|product_template
  "file": file // PDF, Doc, Docx, Xls, Xlsx (Max 5MB)
}
```

#### Get Documents

```
GET /supplier/company/documents?page=1&per_page=20
```

---

## 👨‍💼 ADMIN ENDPOINTS

### Dashboard

#### Get Overview

```
GET /admin/dashboard/overview
Response:
{
  "success": true,
  "data": {
    "total_users": 1000,
    "total_buyers": 700,
    "total_suppliers": 300,
    "total_companies": 280,
    "verified_suppliers": 250,
    "total_orders": 5000,
    "pending_orders": 100,
    "completed_orders": 4500,
    "total_revenue": 2500000.00
  }
}
```

#### Get Analytics

```
GET /admin/dashboard/analytics?period=month // month|year
```

### Suppliers Management

#### List All Suppliers

```
GET /admin/suppliers?status=pending&search=company%20name
// status: all|verified|pending
```

#### Get Supplier Details

```
GET /admin/suppliers/{company_id}
```

#### Verify/Unverify Supplier

```
POST /admin/suppliers/{company_id}/verify
{ "status": true } // or false
```

#### Suspend Supplier

```
DELETE /admin/suppliers/{company_id}/suspend
```

### Orders Management

#### Get All Orders

```
GET /admin/orders?status=pending&payment_status=pending&search=order_id
```

#### Get Order Details

```
GET /admin/orders/{order_id}
```

#### Update Order Status

```
PUT /admin/orders/{order_id}/status
{ "status": "delivered" }
```

#### Schedule Delivery

```
POST /admin/orders/{order_id}/schedule-delivery
{ "scheduled_delivery": "2026-03-15" }
```

#### Get Ready for Delivery Orders

```
GET /admin/orders/ready-for-delivery
```

### Products & Categories

#### Get All Products

```
GET /admin/products?category_id=1&supplier_id=5&search=laptop
```

#### Get Categories

```
GET /admin/categories?page=1&per_page=20
```

#### Create Category

```
POST /admin/categories
{
  "name": "Electronics",
  "description": "Electronic products"
}
```

#### Update Category

```
PUT /admin/categories/{category_id}
{
  "name": "Updated Category",
  "description": "Updated description"
}
```

#### Delete Category

```
DELETE /admin/categories/{category_id}
```

### Ratings Management

#### Get All Ratings

```
GET /admin/ratings?supplier_id=5&min_rating=4&page=1&per_page=20
```

#### Get Ratings Statistics

```
GET /admin/ratings/statistics
Response:
{
  "success": true,
  "data": {
    "total_ratings": 500,
    "average_rating": 4.6,
    "distribution": {
      "5": 300,
      "4": 150,
      "3": 40,
      "2": 8,
      "1": 2
    }
  }
}
```

---

## Response Format

All successful responses follow this format:

```json
{
  "success": true,
  "message": "Operation successful",
  "data": { ... }
}
```

All error responses:

```json
{
    "success": false,
    "message": "Error description"
}
```

---

## Status Codes

- `200` - OK
- `201` - Created
- `400` - Bad Request
- `401` - Unauthorized
- `403` - Forbidden
- `404` - Not Found
- `422` - Unprocessable Entity (Validation Error)
- `500` - Server Error

---

## Rate Limiting

API calls are rate-limited to 1000 requests per hour per IP.

---

## Middleware & Authorization

- **buyer**: Restricts endpoint to users with `role = 'buyer'`
- **supplier**: Restricts endpoint to users with `role = 'supplier'`
- **admin**: Restricts endpoint to users with `role = 'admin'`

---

## Error Handling

Validation errors return 422 with details:

```json
{
    "success": false,
    "message": "Validation failed",
    "errors": {
        "email": ["The email field is required"],
        "password": ["The password must be at least 8 characters"]
    }
}
```

---

## Pagination

Endpoints supporting pagination accept:

- `page`: Page number (default: 1)
- `per_page`: Items per page (default: 20, max: 100)

Response includes:

```json
{
  "data": [ ... ],
  "current_page": 1,
  "last_page": 5,
  "per_page": 20,
  "total": 100
}
```

---

## File Uploads

- Max file size: 5MB for documents, 2MB for images
- Supported formats:
    - **Documents**: PDF, DOC, DOCX, XLS, XLSX
    - **Images**: JPEG, PNG, JPG, GIF

---

## Next Steps

1. Generate API token for testing
2. Use Postman or similar tool to test endpoints
3. Implement frontend integration
4. Set up real-time notifications (if needed)
