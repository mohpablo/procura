import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saas_app/core/di/service_locator.dart';
import 'package:saas_app/core/routes/app_routes.dart';
import 'package:saas_app/core/routes/route_generator.dart';
import 'package:saas_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:saas_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:saas_app/features/cart/presentation/cubit/cart_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup dependency injection
  await setupServiceLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<AuthCubit>()),
        BlocProvider(create: (context) => sl<CartCubit>()),
        BlocProvider(create: (context) => sl<HomeCubit>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'B2B Procurement',
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6366F1),
            primary: const Color(0xFF6366F1),
            secondary: const Color(0xFF1E293B),
            surface: Colors.white,
            background: const Color(0xFFF8FAFC),
            error: const Color(0xFFEF4444),
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onSurface: const Color(0xFF1E293B),
            onBackground: const Color(0xFF1E293B),
          ),
          scaffoldBackgroundColor: const Color(0xFFF8FAFC),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Color(0xFF1E293B),
            elevation: 0,
            centerTitle: true,
            titleTextStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
          cardTheme: CardThemeData(
            color: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey.shade200),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFEF4444)),
            ),
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
          textTheme: const TextTheme(
            headlineLarge: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E293B),
              letterSpacing: -1,
            ),
            headlineMedium: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
            titleLarge: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
            bodyLarge: TextStyle(
              fontSize: 16,
              color: Color(0xFF334155),
              height: 1.5,
            ),
            bodyMedium: TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
              height: 1.5,
            ),
          ),
        ),
        initialRoute: AppRoutes.login,
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
