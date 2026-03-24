import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saas_app/core/theme/screen_helper.dart';
import 'package:saas_app/core/routes/app_routes.dart';
import 'package:saas_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:saas_app/features/auth/presentation/widgets/auth_container.dart';
import 'package:saas_app/features/auth/presentation/widgets/auth_logo.dart';
import 'package:saas_app/features/auth/presentation/widgets/custom_text_field.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final roleNotifier = ValueNotifier<String?>("buyer");
  final isPasswordVisible = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    roleNotifier.dispose();
    isPasswordVisible.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenHelper.init(context);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthBuyerSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Login Successful - Buyer")),
          );
          Navigator.pushReplacementNamed(
            context,
            AppRoutes.buyerHome,
            arguments: state.user,
          );
        }

        if (state is AuthSupplierSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Login Successful - Supplier")),
          );
          Navigator.pushReplacementNamed(
            context,
            AppRoutes.supplierHome,
            arguments: state.user,
          );
        }

        if (state is AuthSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Login Successful")));
          Navigator.pushReplacementNamed(
            context,
            AppRoutes.buyerHome,
            arguments: state.user,
          );
        }

        if (state is AuthError) {
          log(state.message);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: AuthContainer(
            colors: colors,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(child: AuthLogo()),
                  const SizedBox(height: 32),
                  Text("Welcome Back", style: theme.textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  Text(
                    "Sign in to continue your journey",
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 32),
                  CustomTextField(
                    controller: _emailController,
                    hintText: "Email address",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Email is required";
                      }
                      if (!RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(value)) {
                        return "Please enter a valid email";
                      }
                      return null;
                    },
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: isPasswordVisible,
                    builder: (context, visible, _) {
                      return CustomTextField(
                        controller: _passwordController,
                        hintText: "Password",
                        obscureText: !visible,
                        suffixIcon: IconButton(
                          icon: Icon(
                            visible ? Icons.visibility : Icons.visibility_off,
                            color: colors.primary,
                          ),
                          onPressed: () =>
                              isPasswordVisible.value = !isPasswordVisible.value,
                        ),
                        keyboardType: visible
                            ? TextInputType.text
                            : TextInputType.visiblePassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password is required";
                          }
                          if (value.length < 6) {
                            return "Password must be at least 6 characters";
                          }
                          return null;
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Login as",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF475569),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ValueListenableBuilder<String?>(
                    valueListenable: roleNotifier,
                    builder: (context, selectedRole, _) {
                      return Row(
                        children: [
                          Expanded(
                            child: _buildRoleOption(
                              context,
                              "buyer",
                              "Buyer",
                              Icons.shopping_bag_outlined,
                              selectedRole == "buyer",
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildRoleOption(
                              context,
                              "supplier",
                              "Supplier",
                              Icons.storefront_outlined,
                              selectedRole == "supplier",
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  if (state is AuthLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<AuthCubit>().login(
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                            roleNotifier.value!,
                          );
                        }
                      },
                      child: const Text("Sign In"),
                    ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.register);
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRoleOption(
    BuildContext context,
    String value,
    String label,
    IconData icon,
    bool isSelected,
  ) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => roleNotifier.value = value,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : Colors.grey.shade300,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey.shade600,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade600,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
