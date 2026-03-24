# Testing Guide - Complete Flow Walkthrough

## System Architecture Overview

```
┌─────────────────────────────────────────────┐
│         FLUTTER MOBILE APP                   │
├─────────────────────────────────────────────┤
│  • Sign In / Sign Up                        │
│  • Buyer Dashboard                          │
│  • Supplier Dashboard                       │
└──────────────┬──────────────────────────────┘
               │
               │ HTTP Requests (Bearer Token)
               │ DIO Client + Dio Interceptor logs
               ↓
┌─────────────────────────────────────────────┐
│    LARAVEL BACKEND API                      │
├─────────────────────────────────────────────┤
│  • POST /api/mobile/login                   │
│  • POST /api/mobile/register                │
│  • POST /api/mobile/logout                  │
│  Sanctum Authentication                     │
└──────────────┬──────────────────────────────┘
               │
               ↓
┌─────────────────────────────────────────────┐
│         DATABASE                             │
├─────────────────────────────────────────────┤
│  • Users table (role: buyer/supplier)       │
│  • Personal Access Tokens (Sanctum)         │
│  • Companies (for suppliers)                │
└─────────────────────────────────────────────┘
```

## Pre-Testing Setup

### Backend Setup

```bash
# Terminal 1: Run Laravel Development Server
cd saas_backend
php artisan migrate        # Ensure migrations ran
php artisan db:seed       # Optional: Seed test data
php artisan serve         # Runs on http://127.0.0.1:8000

# Terminal 2: Check logs (optional)
tail -f storage/logs/laravel.log
```

### Mobile App Setup

```bash
# Terminal 3: Run Flutter
cd saas_app
flutter pub get           # Get dependencies
flutter run              # Run on device/simulator
```

## Test Scenarios

### Scenario 1: Buyer Login Flow

```
┌─────────────────────────────────────────────┐
│         BUYER LOGIN TEST                     │
└─────────────────────────────────────────────┘

Objective: Verify buyer can login and see buyer dashboard

Test Data:
  Email: buyer@example.com
  Password: password123
  Role: Buyer (from dropdown)

Steps:
  1. App launches → Sign In screen visible
  2. Enter email: buyer@example.com
  3. Enter password: password123
  4. Tap dropdown, select "Buyer"
  5. Tap "Sign In" button
  6. Observe: Loading indicator appears

  Expected Results:
  ✓ API call: POST /api/mobile/login
  ✓ Request body includes role: "buyer"
  ✓ Response status: 200
  ✓ Snackbar: "Login Successful - Buyer"
  ✓ Navigate to BuyerDashboard
  ✓ Display: "Welcome, [Buyer Name]!"
  ✓ Show quick action cards (Browse, Cart, Orders, Notifications)
  ✓ Bottom nav shows: Home, Search, Cart, Profile

  Data Verification:
  • Token saved in SecureStorage
  • User data saved in SecureStorage
  • Role saved as "buyer" in SecureStorage

  Debugging (if failed):
  - Check Flutter console for error message
  - Verify backend is running
  - Check database for user record
  - Verify email/password are correct
```

### Scenario 2: Supplier Login Flow

```
┌─────────────────────────────────────────────┐
│      SUPPLIER LOGIN TEST                     │
└─────────────────────────────────────────────┘

Objective: Verify supplier can login and see supplier dashboard

Test Data:
  Email: supplier@example.com
  Password: password123
  Role: Supplier (from dropdown)

Steps:
  1. From Sign In screen
  2. Enter email: supplier@example.com
  3. Enter password: password123
  4. Tap dropdown, select "Supplier"
  5. Tap "Sign In" button
  6. Observe: Loading indicator appears

  Expected Results:
  ✓ API call: POST /api/mobile/login
  ✓ Request body includes role: "supplier"
  ✓ Response status: 200
  ✓ Snackbar: "Login Successful - Supplier"
  ✓ Navigate to SupplierDashboard
  ✓ Display: "Welcome, [Supplier Name]!"
  ✓ Show stats cards (Revenue, Orders, Products)
  ✓ Show action cards (Add Product, Bulk Upload, etc.)
  ✓ Bottom nav shows: Home, Products, Orders, Profile

  Data Verification:
  • Token saved in SecureStorage
  • User data saved in SecureStorage
  • Role saved as "supplier" in SecureStorage

  Debugging (if failed):
  - Check Flutter console for error message
  - Verify backend is running
  - Check database for supplier record
  - Verify company_id is set correctly
```

### Scenario 3: Validation Testing

```
┌─────────────────────────────────────────────┐
│        VALIDATION TEST                       │
└─────────────────────────────────────────────┘

Test Case 3.1: Empty Email
  Input: Email = "" (empty)
  Input: Password = "password123"
  Expected: Error message "Email is required"
  Should NOT make API call

Test Case 3.2: Invalid Email Format
  Input: Email = "notanemail"
  Input: Password = "password123"
  Expected: Error message "Please enter a valid email"
  Should NOT make API call

Test Case 3.3: Short Password
  Input: Email = "user@example.com"
  Input: Password = "123" (3 chars)
  Expected: Error message "Password must be at least 6 characters"
  Should NOT make API call

Test Case 3.4: Empty Password
  Input: Email = "user@example.com"
  Input: Password = "" (empty)
  Expected: Error message "Password is required"
  Should NOT make API call

Test Case 3.5: No Role Selected
  Input: Role dropdown = None
  Expected: Cannot submit (button disabled or error)

Validation Summary:
  ✓ All validations trigger before API call
  ✓ Error messages are clear and helpful
  ✓ User cannot proceed with invalid data
```

### Scenario 4: Invalid Credentials Test

```
┌─────────────────────────────────────────────┐
│     INVALID CREDENTIALS TEST                 │
└─────────────────────────────────────────────┘

Objective: Verify proper error handling

Test Case 4.1: Wrong Password
  Email: buyer@example.com
  Password: wrongpassword123
  Role: Buyer

  Expected Results:
  • API call made: POST /api/mobile/login
  • Response status: 401 Unauthorized
  • Snackbar shows error message
  • Stay on Sign In screen
  • Do NOT save token or user data

Test Case 4.2: Non-existent User
  Email: nonexistent@example.com
  Password: password123
  Role: Buyer

  Expected Results:
  • API call made: POST /api/mobile/login
  • Response status: 401 or 404
  • Snackbar shows error message
  • Stay on Sign In screen

Test Case 4.3: Backend Not Running
  (Stop backend server)
  Email: buyer@example.com
  Password: password123

  Expected Results:
  • Loading indicator shows
  • After timeout: Error message "Connection refused" or similar
  • Stay on Sign In screen
```

### Scenario 5: Sign Up Flow (Buyer)

```
┌─────────────────────────────────────────────┐
│     BUYER SIGN UP TEST                       │
└─────────────────────────────────────────────┘

Objective: Verify buyer registration

Test Data:
  Role: Buyer
  Name: Alice Buyer
  Email: alice@example.com
  Password: newpassword123 (at least 6 chars)
  Phone: 1234567890
  Address: 123 Main Street

Steps:
  1. Sign In screen → Tap "Sign Up" link
  2. Form Page 1:
     - Select Role: Buyer
     - Enter Name: Alice Buyer
     - Enter Email: alice@example.com
     - Enter Password: newpassword123
     - Enter Phone: 1234567890
     - Enter Address: 123 Main Street
  3. Tap "Create Account" button

  Expected Results:
  ✓ API call: POST /api/mobile/register
  ✓ Request includes all fields
  ✓ Response status: 201 Created (or 200 OK)
  ✓ Snackbar shows success message
  ✓ Navigate to Sign In screen
  ✓ User can now log in with new credentials
```

### Scenario 6: Sign Up Flow (Supplier)

```
┌─────────────────────────────────────────────┐
│    SUPPLIER SIGN UP TEST                     │
└─────────────────────────────────────────────┘

Objective: Verify supplier registration with company info

Test Data - Page 1:
  Role: Supplier
  Name: Bob Supplier
  Email: bob@example.com
  Password: newpassword123
  Phone: 9876543210
  Address: 456 Business Ave

Test Data - Page 2:
  Company Name: ABC Supplies Inc
  Company Phone: 5555555555
  Company Address: 789 Corporate Blvd
  Description: Quality products supplier

Steps:
  1. Sign In screen → Tap "Sign Up" link
  2. Form Page 1 (User Info):
     - Fill as shown above
     - Tap "Next" button
  3. Form Page 2 (Company Info):
     - Fill company details as shown
     - Tap "Create Account" button

  Expected Results:
  ✓ Multi-page form works correctly
  ✓ Can navigate between pages
  ✓ Data persists between pages
  ✓ API call: POST /api/mobile/register
  ✓ Request includes company info
  ✓ Response status: 201 Created
  ✓ Navigate to Sign In screen
  ✓ User can log in as supplier
```

## Expected API Payloads

### Login Request

```json
{
  "email": "buyer@example.com",
  "password": "password123",
  "role": "buyer"
}
```

### Login Response (Success)

```json
{
  "token": "1|qwerty1234567890abcdefghijklmnop",
  "token_type": "Bearer",
  "user": {
    "id": 1,
    "name": "John Buyer",
    "email": "buyer@example.com",
    "role": "buyer",
    "phone": "123-456-7890",
    "address": "123 Main Street",
    "company_id": null
  }
}
```

### Login Response (Error)

```json
{
  "message": "Invalid credentials"
}
```

## Debugging Commands

### Flutter Debugging

```bash
# Show all logs
flutter logs

# Run with verbose output
flutter run -v

# Check stored data (in any widget)
void _printStorageData() async {
  final storage = SecureStorage();
  print('Token: ${await storage.getToken()}');
  print('User: ${await storage.getUser()}');
  print('Role: ${await storage.getUserRole()}');
}
```

### Backend Debugging

```bash
# Tail Laravel logs
tail -f storage/logs/laravel.log

# Check user in database
php artisan tinker
>>> User::all()
>>> User::where('email', 'buyer@example.com')->first()

# Check tokens (Sanctum)
>>> DB::table('personal_access_tokens')->get()
```

## Checklist for QA

### Functionality

- [ ] Buyer login works
- [ ] Supplier login works
- [ ] Buyer dashboard displays correct UI
- [ ] Supplier dashboard displays correct UI
- [ ] All validations work
- [ ] Error messages are helpful
- [ ] Sign up flow completes successfully
- [ ] User data persists

### UI/UX

- [ ] Loading indicator shows during API call
- [ ] All text is readable
- [ ] Buttons are clickable
- [ ] Navigation works smoothly
- [ ] No layout issues
- [ ] Consistent styling

### Security

- [ ] Passwords are not shown in plain text
- [ ] Token is stored securely
- [ ] No sensitive data in logs
- [ ] Bearer token used in API calls
- [ ] Token sent in Authorization header

### Performance

- [ ] Login completes in < 2 seconds
- [ ] No app freezing during loading
- [ ] Smooth transitions between screens
- [ ] No memory leaks after multiple logins

## Troubleshooting Common Issues

### Issue: "Connection refused"

```
Cause: Backend server not running
Solution:
  1. Start backend: php artisan serve
  2. Check URL in api_endpoints.dart
  3. Verify IP address matches
```

### Issue: "Invalid credentials"

```
Cause: Wrong email/password or user doesn't exist
Solution:
  1. Verify credentials in database
  2. Check password hashing algorithm matches
  3. Try registering new test user
```

### Issue: "Null check operator used on null value"

```
Cause: API response missing expected fields
Solution:
  1. Check API response structure
  2. Verify user object is returned
  3. Check null safety in JSON parsing
```

### Issue: Token not persisting

```
Cause: SecureStorage not working
Solution:
  1. Run: flutter clean && flutter pub get
  2. Check permissions on Android/iOS
  3. Restart app and try again
```

---

## Summary

This testing guide provides:

- ✅ Complete test scenarios
- ✅ Expected results for each scenario
- ✅ API payload examples
- ✅ Debugging commands
- ✅ QA checklist
- ✅ Troubleshooting guide

Ready to start testing! 🚀
