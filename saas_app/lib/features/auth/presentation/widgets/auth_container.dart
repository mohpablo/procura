import 'package:flutter/material.dart';
import 'package:saas_app/core/theme/screen_helper.dart';

class AuthContainer extends StatelessWidget {
  const AuthContainer({super.key, required this.colors, required this.child});

  final ColorScheme colors;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          width: context.screenWidth * 0.9,
          constraints: BoxConstraints(
            maxWidth: 450,
            minHeight: context.screenHeight * 0.6,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 32),
            child: child,
          ),
        ),
      ),
    );
  }
}
