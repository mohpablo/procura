import 'package:flutter/material.dart';

class CustomDropdownField<T> extends StatelessWidget {
  const CustomDropdownField({
    super.key,
    required this.valueNotifier,
    required this.hintText,
    required this.items,
    this.initialValue,
  });

  final ValueNotifier<T?> valueNotifier;
  final String hintText;
  final List<DropdownMenuItem<T>> items;
  final T? initialValue;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<T?>(
      valueListenable: valueNotifier,
      builder: (context, value, _) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hintText,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF475569),
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<T>(
                value: value ?? initialValue,
                items: items,
                onChanged: (newValue) {
                  valueNotifier.value = newValue;
                },
                icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 24),
                decoration: InputDecoration(hintText: hintText),
              ),
            ],
          ),
        );
      },
    );
  }
}
