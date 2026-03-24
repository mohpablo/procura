import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saas_app/features/auth/presentation/cubit/auth_cubit.dart';

import 'package:saas_app/features/auth/presentation/widgets/auth_container.dart';
import 'package:saas_app/features/auth/presentation/widgets/auth_logo.dart';
import 'package:saas_app/features/auth/presentation/widgets/custom_text_field.dart';

import 'package:saas_app/core/routes/app_routes.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _companyAddressController =
      TextEditingController();
  final roleNotifier = ValueNotifier<String?>("buyer");
  final companyTypeNotifier = ValueNotifier<String?>("both");
  final isPasswordVisible = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _companyNameController.dispose();
    _companyAddressController.dispose();
    roleNotifier.dispose();
    companyTypeNotifier.dispose();
    isPasswordVisible.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthBuyerSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Buyer Registration successful!')),
          );
          Navigator.pushReplacementNamed(
            context,
            AppRoutes.buyerHome,
            arguments: state.user,
          );
        }
        if (state is AuthSupplierSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Supplier Registration successful!')),
          );
          Navigator.pushReplacementNamed(
            context,
            AppRoutes.supplierHome,
            arguments: state.user,
          );
        }
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: AuthContainer(
            colors: colors,
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(child: AuthLogo()),
                    const SizedBox(height: 32),
                    Text(
                      "Create Account",
                      style: theme.textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Join our B2B marketplace today",
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 32),
                    CustomTextField(
                      controller: _nameController,
                      hintText: "Full name",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Name is required";
                        }
                        return null;
                      },
                    ),
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
                    CustomTextField(
                      controller: _phoneController,
                      hintText: "Phone number",
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Phone is required";
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
                      "I am a",
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
                        return Column(
                          children: [
                            Row(
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
                            ),
                            const SizedBox(height: 24),
                            CustomTextField(
                              controller: _companyNameController,
                              hintText: "Company Name",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Company name is required";
                                }
                                return null;
                              },
                            ),
                            const Text(
                              "Company Type",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF475569),
                              ),
                            ),
                            const SizedBox(height: 8),
                            ValueListenableBuilder<String?>(
                              valueListenable: companyTypeNotifier,
                              builder: (context, type, _) {
                                return DropdownButtonFormField<String>(
                                  value: type,
                                  items: const [
                                    DropdownMenuItem(
                                      value: "buyer",
                                      child: Text("Buyer"),
                                    ),
                                    DropdownMenuItem(
                                      value: "supplier",
                                      child: Text("Supplier"),
                                    ),
                                    DropdownMenuItem(
                                      value: "both",
                                      child: Text("Both"),
                                    ),
                                  ],
                                  onChanged: (newValue) {
                                    companyTypeNotifier.value = newValue;
                                  },
                                  decoration: const InputDecoration(
                                    hintText: "Select Company Type",
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: _companyAddressController,
                              hintText: "Company Address",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Address is required";
                                }
                                return null;
                              },
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
                            context.read<AuthCubit>().register(
                              name: _nameController.text.trim(),
                              email: _emailController.text.trim(),
                              password: _passwordController.text.trim(),
                              passwordConfirmation: _passwordController.text
                                  .trim(),
                              role: roleNotifier.value!,
                              phone: _phoneController.text.trim(),
                              companyName: _companyNameController.text.trim(),
                              companyType: companyTypeNotifier.value,
                              companyAddress: _companyAddressController.text.trim(),
                            );
                          }
                        },
                        child: const Text("Create Account"),
                      ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                              context,
                              AppRoutes.login,
                            );
                          },
                          child: Text(
                            "Sign In",
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
