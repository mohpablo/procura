# Quick Start - Role-Based Login Testing

## What's New ✨

### Two-Step Authenticated Login

1. **Sign In View** - Choose role (Buyer or Supplier) before login
2. **Role-Based Dashboard** - Different UI for each role

### Buyer Dashboard

- ✅ Browse suppliers and products
- ✅ Manage shopping cart
- ✅ Track orders
- ✅ View notifications
- ✅ Rate suppliers

### Supplier Dashboard

- ✅ Manage products
- ✅ Bulk upload products (CSV/Excel)
- ✅ View incoming orders
- ✅ Track revenue
- ✅ View ratings

---

## How to Test

### Step 1: Start Your Backend

```bash
# Navigate to saas_backend
cd saas_backend

# Start Laravel development server
php artisan serve

# Server should be running at: http://192.168.1.7:8000
```

### Step 2: Run Flutter App

```bash
# Navigate to saas_app
cd saas_app

# Get dependencies
flutter pub get

# Run the app
flutter run

# For iOS
flutter run -d <device_id>

# For Android
flutter run -d <device_id>
```

### Step 3: Test Buyer Login

**Scenario:** A buyer wants to login and browse products

```
1. Screen: Sign In Page
   - Email: buyer@example.com
   - Password: password123
   - Role: Buyer (selected from dropdown)
   - Button: "Sign In"

2. Expected Result:
   - Success message: "Login Successful - Buyer"
   - Navigate to Buyer Dashboard
   - Display buyer name and email
   - Show action cards for browsing
```

### Step 4: Test Supplier Login

**Scenario:** A supplier wants to login and manage products

```
1. Screen: Sign In Page
   - Email: supplier@example.com
   - Password: password123
   - Role: Supplier (selected from dropdown)
   - Button: "Sign In"

2. Expected Result:
   - Success message: "Login Successful - Supplier"
   - Navigate to Supplier Dashboard
   - Display supplier name and email
   - Show revenue/orders/products stats
   - Show product management options
```

### Step 5: Test Sign Up

**For Buyer:**

```
1. Tap "Sign Up" link
2. Fill Form (Page 1/1):
   - Role: Buyer
   - Name: John Buyer
   - Email: johnbuyer@example.com
   - Phone: 1234567890
   - Address: 123 Main St
3. Tap "Create Account"
```

**For Supplier:**

```
1. Tap "Sign Up" link
2. Fill Form (Page 1/2):
   - Role: Supplier
   - Name: Jane Supplier
   - Email: janesupplier@example.com
   - Phone: 9876543210
   - Address: 456 Business Ave
3. Tap "Next"
4. Fill Form (Page 2/2):
   - Company Name: Acme Corp
   - Company Phone: 5555555555
   - Company Address: 789 Corporate Blvd
   - Description: Quality products supplier
5. Tap "Create Account"
```

---

## API Endpoints Used

### Login Endpoint

```
POST /api/mobile/login
Content-Type: application/json

Request:
{
  "email": "user@example.com",
  "password": "password123",
  "role": "buyer"  // or "supplier"
}

Response (200):
{
  "token": "eyJ0eXAi...",
  "token_type": "Bearer",
  "user": {
    "id": 1,
    "name": "John Buyer",
    "email": "user@example.com",
    "role": "buyer",
    "phone": "1234567890",
    "address": "123 Main St",
    "company_id": null
  }
}
```

### Register Endpoint

```
POST /api/mobile/register
Content-Type: application/json

Request:
{
  "name": "New User",
  "email": "newuser@example.com",
  "password": "password123",
  "role": "buyer"
}

Response (201):
{
  "token": "eyJ0eXAi...",
  "token_type": "Bearer",
  "user": { ... }
}
```

---

## Authentication Flow Diagram

```
┌─────────────────────┐
│   Sign In Screen    │
│  [Email]            │
│  [Password]         │
│ [Buyer/Supplier]    │
│  [Sign In Button]   │
└──────────┬──────────┘
           │
           ↓
     ┌──────────────┐
     │ AuthCubit    │
     │ .login()     │
     └──────┬───────┘
            │
            ↓
    ┌─────────────────┐
    │ DIO HTTP Call   │
    │ POST /login     │
    └────────┬────────┘
             │
             ↓
      ┌──────────────────┐
      │ Parse Response   │
      │ Extract User     │
      │ Extract Token    │
      └────────┬─────────┘
             │
             ↓
    ┌─────────────────────┐
    │ Save to Storage     │
    │ - Token             │
    │ - User Data         │
    │ - User Role         │
    └────────┬────────────┘
             │
     ┌───────┴────────┐
     │                │
  Buyer?          Supplier?
     │                │
     ↓                ↓
  Buyer          Supplier
Dashboard       Dashboard
```

---

## State Management Overview

### AuthCubit Emits These States:

```dart
AuthInitial              // App start

↓ (User taps Sign In)

AuthLoading              // Calling API

↓ (API Response)

AuthBuyerSuccess(user)   // Role = 'buyer'
     ↓
  Navigate to BuyerDashboard

OR

AuthSupplierSuccess(user) // Role = 'supplier'
     ↓
  Navigate to SupplierDashboard

OR

AuthError(message)       // Failed
     ↓
  Show Error Snackbar
```

---

## File Changes Made

### Modified Files:

- ✅ `lib/main.dart` - Added dashboard routes
- ✅ `lib/core/database/secure_storage.dart` - Added user/role storage
- ✅ `lib/features/auth/presentation/cubit/auth_cubit.dart` - Role handling
- ✅ `lib/features/auth/presentation/cubit/auth_state.dart` - New states
- ✅ `lib/features/auth/presentation/views/sigin_in_view.dart` - Dashboard navigation
- ✅ `lib/features/auth/data/datasources/auth_remote_data_source.dart` - Response parsing
- ✅ `lib/features/auth/data/repositories/auth_repository_impl.dart` - User saving
- ✅ `lib/features/auth/domain/repositories/auth_repository.dart` - Interface update
- ✅ `lib/features/auth/domain/usecases/login_usecase.dart` - Return type update

### New Files:

- ✅ `lib/features/home/presentation/views/buyer_dashboard.dart`
- ✅ `lib/features/home/presentation/views/supplier_dashboard.dart`
- ✅ `lib/features/auth/data/models/login_response_model.dart`

---

## Debugging Tips

### Enable Dart DevTools:

```bash
flutter pub global activate devtools
devtools
```

### Check Token in Storage:

```dart
final storage = SecureStorage();
print(await storage.getToken());
print(await storage.getUser());
print(await storage.getUserRole());
```

### View API Logs:

- Check Flutter console (Dio LogInterceptor enabled)
- Look for POST request to `/login`
- Check response status and data

### Common Error Messages:

- ❌ "Connection refused" → Backend not running
- ❌ "Invalid credentials" → Wrong email/password
- ❌ "Null check operator used on null value" → Missing response data

---

## What's Next?

After successful authentication:

1. Implement product browsing (Buyer feature)
2. Implement cart functionality
3. Implement order management
4. Add notifications
5. Implement payment processing
6. Analytics dashboard

---

**Ready to Test?**

```bash
cd saas_app
flutter run
```

Tap Sign In → Enter credentials → Choose role → View dashboard! 🎉
