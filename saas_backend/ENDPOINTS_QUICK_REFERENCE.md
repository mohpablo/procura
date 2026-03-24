# API Endpoints Quick Reference

## Authentication (Public)

| Method | Endpoint         | Description       | Auth |
| ------ | ---------------- | ----------------- | ---- |
| POST   | `/auth/register` | Register new user | ❌   |
| POST   | `/auth/login`    | Login user        | ❌   |

## Authentication (Protected)

| Method | Endpoint              | Description      | Role |
| ------ | --------------------- | ---------------- | ---- |
| POST   | `/auth/logout`        | Logout user      | All  |
| POST   | `/auth/refresh-token` | Refresh token    | All  |
| GET    | `/auth/me`            | Get current user | All  |

## Products (Public)

| Method | Endpoint             | Description                | Auth |
| ------ | -------------------- | -------------------------- | ---- |
| GET    | `/products`          | List products with filters | ❌   |
| GET    | `/products/{id}`     | Get product details        | ❌   |
| GET    | `/products/featured` | Get featured products      | ❌   |
| GET    | `/categories`        | List categories            | ❌   |

## 👤 BUYER ENDPOINTS

### Profile

| Method | Endpoint            | Description          |
| ------ | ------------------- | -------------------- |
| GET    | `/buyer/profile`    | Get buyer profile    |
| PUT    | `/buyer/profile`    | Update profile       |
| GET    | `/buyer/statistics` | Get buyer statistics |

### Cart

| Method | Endpoint                   | Description      |
| ------ | -------------------------- | ---------------- |
| GET    | `/buyer/cart`              | Get cart         |
| POST   | `/buyer/cart/add`          | Add to cart      |
| PUT    | `/buyer/cart/{product_id}` | Update cart item |
| DELETE | `/buyer/cart/{product_id}` | Remove from cart |
| POST   | `/buyer/cart/clear`        | Clear cart       |

### Orders

| Method | Endpoint                    | Description       |
| ------ | --------------------------- | ----------------- |
| GET    | `/buyer/orders`             | List buyer orders |
| POST   | `/buyer/orders/checkout`    | Create order      |
| GET    | `/buyer/orders/{id}`        | Get order details |
| POST   | `/buyer/orders/{id}/cancel` | Cancel order      |
| GET    | `/buyer/orders/{id}/track`  | Track order       |

### Ratings

| Method | Endpoint                   | Description            |
| ------ | -------------------------- | ---------------------- |
| GET    | `/buyer/ratings/available` | Get deliverable orders |
| POST   | `/buyer/ratings`           | Submit rating          |

### Notifications

| Method | Endpoint                             | Description       |
| ------ | ------------------------------------ | ----------------- |
| GET    | `/buyer/notifications`               | Get notifications |
| PUT    | `/buyer/notifications/{id}/read`     | Mark as read      |
| POST   | `/buyer/notifications/mark-all-read` | Mark all as read  |
| GET    | `/buyer/notifications/unread-count`  | Get unread count  |

---

## 🏭 SUPPLIER ENDPOINTS

### Dashboard

| Method | Endpoint                            | Description        |
| ------ | ----------------------------------- | ------------------ |
| GET    | `/supplier/dashboard/overview`      | Dashboard overview |
| GET    | `/supplier/dashboard/recent-orders` | Recent orders      |
| GET    | `/supplier/dashboard/order-stats`   | Order statistics   |
| GET    | `/supplier/dashboard/revenue`       | Revenue analytics  |

### Products

| Method | Endpoint                               | Description    |
| ------ | -------------------------------------- | -------------- |
| GET    | `/supplier/products`                   | List products  |
| POST   | `/supplier/products`                   | Create product |
| GET    | `/supplier/products/{id}`              | Get product    |
| PUT    | `/supplier/products/{id}`              | Update product |
| DELETE | `/supplier/products/{id}`              | Delete product |
| POST   | `/supplier/products/bulk-update-stock` | Update stock   |

### Orders

| Method | Endpoint                                   | Description    |
| ------ | ------------------------------------------ | -------------- |
| GET    | `/supplier/orders`                         | List orders    |
| GET    | `/supplier/orders/{id}`                    | Get order      |
| POST   | `/supplier/orders/{id}/confirm`            | Confirm/reject |
| PUT    | `/supplier/orders/{id}/status`             | Update status  |
| POST   | `/supplier/orders/{id}/ready-for-delivery` | Mark ready     |
| GET    | `/supplier/orders/pending/count`           | Pending count  |

### Company

| Method | Endpoint                      | Description         |
| ------ | ----------------------------- | ------------------- |
| GET    | `/supplier/company`           | Get company profile |
| PUT    | `/supplier/company`           | Update company      |
| GET    | `/supplier/company/ratings`   | Get ratings         |
| POST   | `/supplier/company/documents` | Upload document     |
| GET    | `/supplier/company/documents` | List documents      |

---

## 👨‍💼 ADMIN ENDPOINTS

### Dashboard

| Method | Endpoint                     | Description        |
| ------ | ---------------------------- | ------------------ |
| GET    | `/admin/dashboard/overview`  | Dashboard overview |
| GET    | `/admin/dashboard/analytics` | Analytics data     |

### Suppliers

| Method | Endpoint                        | Description      |
| ------ | ------------------------------- | ---------------- |
| GET    | `/admin/suppliers`              | List suppliers   |
| GET    | `/admin/suppliers/{id}`         | Get supplier     |
| POST   | `/admin/suppliers/{id}/verify`  | Verify supplier  |
| DELETE | `/admin/suppliers/{id}/suspend` | Suspend supplier |

### Orders

| Method | Endpoint                               | Description       |
| ------ | -------------------------------------- | ----------------- |
| GET    | `/admin/orders`                        | List orders       |
| GET    | `/admin/orders/{id}`                   | Get order         |
| PUT    | `/admin/orders/{id}/status`            | Update status     |
| POST   | `/admin/orders/{id}/schedule-delivery` | Schedule delivery |
| GET    | `/admin/orders/ready-for-delivery`     | Ready orders      |

### Products & Categories

| Method | Endpoint                 | Description     |
| ------ | ------------------------ | --------------- |
| GET    | `/admin/products`        | List products   |
| GET    | `/admin/categories`      | List categories |
| POST   | `/admin/categories`      | Create category |
| PUT    | `/admin/categories/{id}` | Update category |
| DELETE | `/admin/categories/{id}` | Delete category |

### Ratings

| Method | Endpoint                    | Description  |
| ------ | --------------------------- | ------------ |
| GET    | `/admin/ratings`            | List ratings |
| GET    | `/admin/ratings/statistics` | Rating stats |

---

## Status Codes Quick Reference

| Code | Meaning          | Example                       |
| ---- | ---------------- | ----------------------------- |
| 200  | OK               | Get request successful        |
| 201  | Created          | Resource created successfully |
| 400  | Bad Request      | Invalid input data            |
| 401  | Unauthorized     | Missing/invalid token         |
| 403  | Forbidden        | Access denied                 |
| 404  | Not Found        | Resource doesn't exist        |
| 422  | Validation Error | Input validation failed       |
| 500  | Server Error     | Internal server error         |

---

## Order Statuses

| Status             | Description                     | Next Transition     |
| ------------------ | ------------------------------- | ------------------- |
| pending            | Order placed, awaiting supplier | confirmed/cancelled |
| confirmed          | Supplier approved order         | preparing           |
| preparing          | Supplier preparing order        | ready_for_delivery  |
| ready_for_delivery | Ready at supplier               | scheduled           |
| scheduled          | Scheduled date set              | delivered           |
| delivered          | Successfully delivered          | N/A                 |
| cancelled          | Order cancelled                 | N/A                 |

---

## Query Parameters

### Common Pagination

```
?page=1&per_page=20
```

### Common Filters

```
?search=keyword
?category_id=1
?supplier_id=5
?status=pending
?sort_by=price_asc
```

### Sorting Options

- `price_asc` - Price low to high
- `price_desc` - Price high to low
- `newest` - Most recent first
- `popular` - Most ordered first

---

## Authentication Header

```
Authorization: Bearer {TOKEN}
```

---

## Content-Type Header

```
Content-Type: application/json
```

For file uploads:

```
Content-Type: multipart/form-data
```

---

## Response Header Example

```
HTTP/1.1 200 OK
Content-Type: application/json
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 999
X-RateLimit-Reset: 1640970000

{
  "success": true,
  "message": "Success",
  "data": { ... }
}
```

---

## Total Endpoints: 60+

- **Public**: 4
- **Buyer**: 20
- **Supplier**: 18
- **Admin**: 18

---

_Last Updated: March 9, 2026_
_API Version: v1_
