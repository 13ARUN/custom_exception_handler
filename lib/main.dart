import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:custom_exception_handler/core/theme/theme.dart';
import 'package:custom_exception_handler/features/number_trivia/presentation/providers/repository_providers.dart';
import 'package:custom_exception_handler/features/number_trivia/presentation/screens/number_trivia_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      theme: AppTheme.themeData,
      debugShowCheckedModeBanner: false,
      home: const NumberTriviaPage(),
    );
  }
}
