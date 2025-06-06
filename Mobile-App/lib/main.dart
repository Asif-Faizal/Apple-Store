import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/firebase/firebase.options.dart';
import 'providers/search.filter.provider.dart';
import 'providers/theme.provider.dart';
import 'providers/auth.provider.dart';
import 'providers/product.provider.dart';
import 'providers/connectivity.provider.dart';
import 'core/widgets/connectivity_wrapper.dart';
import 'views/splash.screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => SearchFilterProvider()),
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
      ],
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
          builder: (context, child) {
            return ConnectivityWrapper(child: child ?? const SizedBox());
          },
        );
      },
    );
  }
}