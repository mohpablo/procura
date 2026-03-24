import 'package:flutter/material.dart';
import 'package:saas_app/core/theme/screen_helper.dart';

class AuthLogo extends StatelessWidget {
  const AuthLogo({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenHelper.init(context);
    return Container(
      height: context.screenWidth * 0.22,
      width: context.screenWidth * 0.22,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.shopping_cart_checkout,
        color: Colors.white,
        size: 50,
      ),
    );
  }
}
