import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'theme/app_colors.dart';

void main() {
  runApp(const CuratedCelebrationApp());
}

class CuratedCelebrationApp extends StatelessWidget {
  const CuratedCelebrationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Curated Celebration',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryContainer,
          primary: AppColors.primary,
          onPrimary: AppColors.onPrimary,
          secondary: AppColors.secondary,
          surface: AppColors.surface,
          error: AppColors.error,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
