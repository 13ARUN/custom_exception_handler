import 'package:flutter/material.dart';
import 'package:custom_exception_handler/core/theme/theme.dart';

class TriviaError extends StatelessWidget {
  final Object error;

  const TriviaError({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppTheme.cardHeight,
      child: Card(
        color: AppTheme.errorColor,
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            error.toString(),
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
