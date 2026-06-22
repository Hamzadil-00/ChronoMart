import 'package:ecommerce_app/screens/category.dart';
import 'package:flutter/material.dart';
import 'screens/loading_screen.dart';
import 'screens/signin_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const WatcheaseApp());
}

class WatcheaseApp extends StatelessWidget {
  const WatcheaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Watchease',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF7DA7FF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ),
        textTheme: ThemeData.dark().textTheme.apply(
          fontFamily: 'Poppins',
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
      ),
      initialRoute: LoadingScreen.routeName,
      routes: {
        LoadingScreen.routeName: (_) => const LoadingScreen(),
        SignInScreen.routeName: (_) => const SignInScreen(),
        SignUpScreen.routeName: (_) => const SignUpScreen(),
        HomeScreen.routeName: (_) => const HomeScreen(),
        CategoriesScreen.routeName: (context) => const CategoriesScreen(),
        CartScreen.routeName : (context) =>  CartScreen(),
        ProfileScreen.routeName: (context) =>  ProfileScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
