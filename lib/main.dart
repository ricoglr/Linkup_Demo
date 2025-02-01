import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:linkup/screens/login_screen.dart';
import 'package:linkup/theme/app_theme.dart';
import 'package:linkup/theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(ChangeNotifierProvider(
      create: (context) => ThemeProvider(), child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
      return MaterialApp(
        title: 'LINK UP',
        debugShowCheckedModeBanner: false,
        theme:
            themeProvider.isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
        themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        home: LoginScreen(),
      );
    });
  }
}
