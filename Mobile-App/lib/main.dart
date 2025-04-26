import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/theme.provider.dart';
import 'views/splash.screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Apple Store',
          theme: themeProvider.themeData,
          home: const SplashScreen(),
        );
      },
    );
  }
}