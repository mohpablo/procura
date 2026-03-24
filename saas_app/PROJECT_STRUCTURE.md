# Project Structure & File Organization

## Complete Directory Tree

```
saas_app/
├── android/                          # Android native code
├── ios/                              # iOS native code
├── lib/
│   ├── main.dart                     # ✏️ App entry point (UPDATED)
│   ├── core/                         # Core utilities & configurations
│   │   ├── api/
│   │   │   ├── api_consumer.dart     # Abstract API interface
│   │   │   ├── dio_consumer.dart     # DIO HTTP client implementation
│   │   │   └── api_endpoints.dart    # API URLs
│   │   ├── database/
│   │   │   └── secure_storage.dart   # ✏️ Encrypted storage (ENHANCED)
│   │   ├── errors/
│   │   │   ├── error_model.dart      # Error response model
│   │   │   └── server_exception.dart # Exception handling
│   │   └── theme/
│   │       └── screen_helper.dart    # Responsive design
│   │
│   └── features/
│       ├── auth/                     # Authentication Feature
│       │   ├── data/
│       │   │   ├── datasources/
│       │   │   │   └── auth_remote_data_source.dart
│       │   │   │       # ✏️ UPDATED: Added LoginResponseModel
│       │   │   │       # - login() returns full response
│       │   │   │       # - register() method
│       │   │   │       # - logout() method
│       │   │   │
│       │   │   ├── models/
│       │   │   │   ├── user_model.dart
│       │   │   │   │   # ✏️ UPDATED: Extends User entity
│       │   │   │   │   # - Serialization methods
│       │   │   │   │   # - Helper methods (isBuyer, isSupplier)
│       │   │   │   │
│       │   │   │   └── login_response_model.dart
│       │   │   │       # 🆕 NEW: Response wrapper
│       │   │   │       # - Token + TokenType + User
│       │   │   │       # - JSON parsing
│       │   │   │
│       │   │   └── repositories/
│       │   │       └── auth_repository_impl.dart
│       │   │           # ✏️ UPDATED: Full implementation
│       │   │           # - Saves token
│       │   │           # - Saves user data
│       │   │           # - Saves role
│       │   │           # - Login/logout flow
│       │   │
│       │   ├── domain/
│       │   │   ├── entities/
│       │   │   │   └── user.dart
│       │   │   │       # Core user entity
│       │   │   │       # - id, name, email, role
│       │   │   │       # - phone, address, companyId
│       │   │   │
│       │   │   ├── repositories/
│       │   │   │   └── auth_repository.dart
│       │   │   │       # ✏️ UPDATED: Interface with all methods
│       │   │   │       # - login()
│       │   │   │       # - logout()
│       │   │   │       # - getCurrentUser()
│       │   │   │       # - getUserRole()
│       │   │   │       # - isUserLoggedIn()
│       │   │   │
│       │   │   └── usecases/
│       │   │       └── login_usecase.dart
│       │   │           # ✏️ UPDATED: Returns User entity
│       │   │           # - Calls repository.login()
│       │   │           # - Clean architecture pattern
│       │   │
│       │   └── presentation/
│       │       ├── cubit/
│       │       │   ├── auth_cubit.dart
│       │       │   │   # ✏️ UPDATED: Role-based state emission
│       │       │   │   # - login() method
│       │       │   │   # - Emits different states
│       │       │   │   # - Error handling
│       │       │   │
│       │       │   └── auth_state.dart
│       │       │       # ✏️ UPDATED: New role-specific states
│       │       │       # - AuthBuyerSuccess
│       │       │       # - AuthSupplierSuccess
│       │       │       # - AuthError
│       │       │
│       │       ├── views/
│       │       │   ├── sigin_in_view.dart
│       │       │   │   # ✏️ UPDATED: Dashboard navigation
│       │       │   │   # - Role selection dropdown
│       │       │   │   # - Navigate to buyer/supplier dashboard
│       │       │   │
│       │       │   └── sign_up_view.dart
│       │       │       # Multi-page form
│       │       │       # - User info page
│       │       │       # - Company info page (for suppliers)
│       │       │
│       │       └── widgets/
│       │           ├── auth_container.dart
│       │           ├── auth_logo.dart
│       │           ├── custom_dropdown_field.dart
│       │           └── custom_text_field.dart
│       │
│       └── home/                    # Home Feature (Dashboards)
│           └── presentation/
│               └── views/
│                   ├── buyer_dashboard.dart
│                   │   # 🆕 NEW: Buyer Dashboard
│                   │   # - Quick action cards
│                   │   # - Bottom navigation
│                   │   # - Recent orders
│                   │
│                   └── supplier_dashboard.dart
│                       # 🆕 NEW: Supplier Dashboard
│                       # - Stats cards
│                       # - Product management
│                       # - Bottom navigation
│
├── test/
│   └── widget_test.dart              # Widget tests
│
├── web/                              # Web deployment files
├── windows/                          # Windows desktop files
├── linux/                            # Linux desktop files
├── macos/                            # macOS desktop files
│
└── Configuration Files:
    ├── pubspec.yaml                  # Dependencies (flutter_bloc, dio, etc)
    ├── pubspec.lock                  # Locked versions
    ├── analysis_options.yaml          # Dart linting rules
    ├── .gitignore                    # Git ignore patterns
    ├── .metadata                     # Flutter metadata
    ├── .flutter-plugins-dependencies # Plugin dependencies
    │
    └── Documentation:
        ├── FLUTTER_AUTH_GUIDE.md     # 📖 Complete guide
        ├── QUICK_START.md             # ⚡ Quick reference
        ├── IMPLEMENTATION_SUMMARY.md  # ✅ What's been done
        ├── TESTING_GUIDE.md           # 🧪 Testing procedures
        └── README.md                  # Project overview

```

## File Status Legend

- ✏️ **UPDATED** - Modified from original
- 🆕 **NEW** - Created for this feature
- ✅ **UNCHANGED** - Existing, no modifications needed

## Key Updates Made

### 1. Core Layer

```
secure_storage.dart - Added:
  • saveUser() / getUser()
  • saveUserRole() / getUserRole()
  • clearAuthData()
  • isUserLoggedIn()
```

### 2. Data Layer

```
auth_remote_data_source.dart - Changed:
  • login() returns LoginResponseModel (not just token)
  • Added register() method
  • Added logout() method

auth_repository_impl.dart - Added:
  • Save user data to storage
  • Save role to storage
  • Login/logout flow
  • Session management
```

### 3. Domain Layer

```
auth_repository.dart - Interface updates:
  • login() returns User instead of String
  • Added logout(), isUserLoggedIn(), getCurrentUser(), getUserRole()

login_usecase.dart - Modified:
  • Now returns User entity
```

### 4. Presentation Layer

```
auth_cubit.dart - Enhanced:
  • Role-based state emission
  • Error handling

auth_state.dart - New states:
  • AuthBuyerSuccess
  • AuthSupplierSuccess
  • AuthError

sigin_in_view.dart - Updated:
  • Navigate to BuyerDashboard
  • Navigate to SupplierDashboard
  • Role-based logic

main.dart - Added:
  • onGenerateRoute for navigation
  • Dashboard route handling
  • User argument passing
```

## Dependencies Used

```yaml
# State Management
flutter_bloc: ^9.1.1
bloc: ^8.1.2

# HTTP Client
dio: ^5.9.2

# Secure Storage
flutter_secure_storage: ^10.0.0

# UI Framework
flutter:
  sdk: flutter
cupertino_icons: ^1.0.8

# Dev Dependencies
flutter_test:
  sdk: flutter
flutter_lints: ^6.0.0
```

## Architecture Pattern: Clean Architecture

```
┌───────────────────────────────────────────────────────┐
│              PRESENTATION LAYER                       │
│  (UI Components)                                      │
│  - Views (SiginInView, Dashboards)                   │
│  - CuBit (AuthCubit)                                 │
│  - States (AuthState)                                │
│  - Widgets (Input fields, buttons)                   │
└────────────────────┬────────────────────────────────┘
                     │
         ┌───────────┴───────────┐
         ↓                       ↓
┌────────────────────┐  ┌────────────────────┐
│  DOMAIN LAYER      │  │  Well-defined      │
│                    │  │  business logic    │
│ - Entities         │  │  independent of    │
│ - Repositories     │  │  implementation    │
│ - UseCases         │  │  details           │
└────────────────────┘  └────────────────────┘
         ↑
         │
┌─────────┴──────────────────────────────────┐
│         DATA LAYER                         │
│  (Repository Implementation, DataSources) │
│  - AuthRepositoryImpl                      │
│  - AuthRemoteDataSource                   │
│  - Local Storage                          │
│  - API Client (DioConsumer)               │
└──────────────────────────────────────────┘
        ↕              ↕
    Backend API    Local Storage
```

## Data Flow: User Login

```
User Input
    ↓
┌─────────────────────┐
│ Sign In View        │
│ • Email field       │
│ • Password field    │
│ • Role dropdown     │
└──────────┬──────────┘
           │ onClick(SignIn)
           ↓
┌─────────────────────┐
│ AuthCubit.login()   │
│ emit(AuthLoading)   │
└──────────┬──────────┘
           │
           ↓
┌─────────────────────┐
│ LoginUseCase        │
│ call(email,pwd,role)│
└──────────┬──────────┘
           │
           ↓
┌─────────────────────┐
│ AuthRepository      │
│ .login()            │
└──────────┬──────────┘
           │
           ↓
┌─────────────────────┐
│ DataSource          │
│ .login()            │
│ POST /login         │
└──────────┬──────────┘
           │
           ↓ API Response
┌─────────────────────┐
│ Parse Response      │
│ Extract: token, user│
└──────────┬──────────┘
           │
           ↓
┌─────────────────────┐
│ Save to Storage     │
│ • Token             │
│ • User Data         │
│ • Role              │
└──────────┬──────────┘
           │
           ↓
┌─────────────────────┐
│ AuthCubit State     │
│ emit(BuyerSuccess)  │
│ or                  │
│ emit(SupplierSuccess)
└──────────┬──────────┘
           │
           ↓
┌─────────────────────┐
│ Navigation          │
│ → BuyerDashboard    │
│ → SupplierDashboard │
└─────────────────────┘
```

## Testing Structure

```
Testing Hierarchy:
├── Unit Tests
│   ├── LoginUseCase tests
│   ├── Repository tests
│   └── Model parsing tests
│
├── Widget Tests
│   ├── Sign In View rendering
│   ├── Dashboard rendering
│   └── Form validation
│
├── Integration Tests
│   ├── Login flow end-to-end
│   ├── Dashboard navigation
│   └── Storage verification
│
└── Manual Testing
    ├── Buyer login scenario
    ├── Supplier login scenario
    ├── Validation scenarios
    ├── Error scenarios
    └── Sign up flow
```

## Deployment Readiness

- ✅ Clean code structure
- ✅ Error handling implemented
- ✅ Security considerations (encrypted storage)
- ✅ No hardcoded secrets
- ✅ Proper logging (Dio interceptor)
- ✅ Responsive design support
- ✅ Cross-platform support (Android/iOS/Web)

---

Generated: March 9, 2026
Status: Ready for Implementation & Testing
