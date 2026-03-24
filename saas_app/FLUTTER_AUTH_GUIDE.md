# Flutter Mobile App - Authentication & Dashboard Implementation Guide

## Overview

This Flutter B2B Procurement mobile app has been enhanced with comprehensive authentication and role-based dashboard navigation. The app now supports two types of users:

- **Buyers** - Browse and purchase products
- **Suppliers** - Manage products and orders

## Architecture

### Authentication Flow

```
User Input (Email, Password, Role)
    ↓
SiginInView (UI)
    ↓
AuthCubit.login()
    ↓
LoginUseCase
    ↓
AuthRepositoryImpl
    ↓
AuthRemoteDataSource (API Call: /login)
    ↓
Parse Response + Save (token, user, role)
    ↓
Emit Role-Specific State (AuthBuyerSuccess / AuthSupplierSuccess)
    ↓
Navigation to Dashboard (Buyer or Supplier)
```

### Data Flow

**Request to Backend:**

```json
{
  "email": "user@example.com",
  "password": "password123",
  "role": "buyer" // or "supplier"
}
```

**Expected Response:**

```json
{
  "token": "eyJ0eXAi...",
  "token_type": "Bearer",
  "user": {
    "id": 1,
    "name": "John Doe",
    "email": "user@example.com",
    "role": "buyer",
    "phone": "1234567890",
    "address": "123 Main St",
    "company_id": null
  }
}
```

## Key Components

### 1. State Management (BLoC Pattern)

**AuthCubit States:**

- `AuthInitial` - Initial state
- `AuthLoading` - During API call
- `AuthBuyerSuccess` - Successful buyer login
- `AuthSupplierSuccess` - Successful supplier login
- `AuthSuccess` - Generic success (fallback)
- `AuthError` - Login failed

### 2. Data Models

**User Entity:**

```dart
User {
  int id
  String name
  String email
  String role ('buyer' or 'supplier')
  String? phone
  String? address
  int? companyId
}
```

**UserModel extends User:**

- Adds JSON serialization
- Includes helper methods: `isBuyer`, `isSupplier`

### 3. Storage Layer

**SecureStorage Features:**

- Saves encrypted auth token
- Saves user data as JSON
- Saves user role
- Methods: `getToken()`, `getUser()`, `getUserRole()`, `clearAuthData()`

### 4. UI Views

#### Sign In Screen (`SiginInView`)

- Email input
- Password input
- Role dropdown (Buyer/Supplier)
- Validation
- Link to Sign Up

#### Buyer Dashboard (`BuyerDashboard`)

**Features:**

- Welcome card with user info
- Quick Action Cards:
  - Browse Products
  - My Cart
  - My Orders
  - Notifications
- Recent Orders Section
- Bottom Navigation (Home, Search, Cart, Profile)

#### Supplier Dashboard (`SupplierDashboard`)

**Features:**

- Welcome card with user info
- Statistics (Revenue, Orders, Products)
- Quick Action Cards:
  - Add Product
  - Bulk Upload
  - My Products
  - My Orders
- Pending Orders Section
- Bottom Navigation (Home, Products, Orders, Profile)

## Testing Guide

### Test Credentials

Contact backend team for test accounts with:

- Buyer account
- Supplier account

### Manual Testing Steps

#### 1. Test Buyer Login

```
1. Launch app
2. Enter buyer email
3. Enter password
4. Select "Buyer" from dropdown
5. Tap "Sign In"
6. Should navigate to Buyer Dashboard
7. Verify user name and email displayed
```

#### 2. Test Supplier Login

```
1. Go back to Sign In (if needed)
2. Enter supplier email
3. Enter password
4. Select "Supplier" from dropdown
5. Tap "Sign In"
6. Should navigate to Supplier Dashboard
7. Verify statistics cards displayed
```

#### 3. Test Sign Up

```
1. Tap "Sign Up" link
2. Fill user information (name, email, phone, address)
3. Select role (Buyer/Supplier)
4. If Supplier: Fill company information
5. Review information
6. Tap Create Account
7. Should navigate to Sign In
```

#### 4. Test Validation

```
1. Try logging in with empty fields
2. Try invalid email format
3. Try password less than 6 characters
4. Try all validations - should show error messages
```

### Debugging

**Check Token Storage:**

```dart
// In any screen:
final storage = SecureStorage();
final token = await storage.getToken();
final user = await storage.getUser();
final role = await storage.getUserRole();
```

**Monitor API Calls:**

- Dio LogInterceptor already enabled
- Check Flutter console for request/response logs

**State Debugging:**

- Add `printBlocStates: true` to enable state logging
- Monitor `AuthCubit` states in flutter tools

## File Structure

```
lib/
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── auth_remote_data_source.dart (Updated)
│   │   │   ├── models/
│   │   │   │   ├── user_model.dart
│   │   │   │   └── login_response_model.dart (New)
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart (Updated)
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart (Updated)
│   │   │   └── usecases/
│   │   │       └── login_usecase.dart (Updated)
│   │   └── presentation/
│   │       ├── cubit/
│   │       │   ├── auth_cubit.dart (Updated)
│   │       │   └── auth_state.dart (Updated)
│   │       └── views/
│   │           ├── sigin_in_view.dart (Updated)
│   │           └── sign_up_view.dart
│   └── home/
│       └── presentation/
│           └── views/
│               ├── buyer_dashboard.dart (New)
│               └── supplier_dashboard.dart (New)
├── core/
│   ├── api/
│   │   └── dio_consumer.dart
│   ├── database/
│   │   └── secure_storage.dart (Updated)
│   └── errors/
│       └── server_exception.dart
└── main.dart (Updated)
```

## API Endpoints Required

### Backend API Configuration

**Base URL:** `http://192.168.1.7:8000/api/mobile`

**Endpoints:**

- `POST /login` - User login
- `POST /register` - User registration
- `POST /logout` - User logout (optional)

## Future Enhancements

1. **Product Module:**
   - Browse products (Buyer)
   - Add/Edit products (Supplier)
   - Bulk upload via CSV/Excel

2. **Order Module:**
   - Create orders (Buyer)
   - View/Confirm orders (Supplier)
   - Order tracking

3. **Cart Module:**
   - Add to cart (Buyer)
   - Checkout flow

4. **Notifications:**
   - Order status updates
   - Delivery notifications
   - Messages

5. **Profile Module:**
   - Edit profile information
   - Update password
   - Logout functionality

6. **Advanced Features:**
   - Ratings and reviews
   - Invoice generation
   - Analytics dashboard (Supplier)

## Troubleshooting

### Common Issues

**Issue:** Login fails with "Connection refused"

- **Solution:** Verify backend server is running at `http://192.168.1.7:8000`

**Issue:** "Invalid credentials" error

- **Solution:** Verify email and password are correct, check backend database

**Issue:** Token not persisting

- **Solution:** Check that Flutter Secure Storage permissions are granted on device

**Issue:** Dashboard not showing user data

- **Solution:** Verify API response includes complete user object

## Dependencies

```yaml
flutter_bloc: ^9.1.1 # State management
dio: ^5.9.2 # HTTP client
flutter_secure_storage: ^10.0.0 # Secure token storage
```

## Environment Setup

```dart
// In lib/core/api/api_endpoints.dart
class EndPoints {
  static const String baseUrl = 'http://192.168.1.7:8000/api/mobile';
  static const String login = '/login';
}
```

Update the IP address to match your backend server.

---

**Last Updated:** March 2026
**Status:** Ready for Testing
