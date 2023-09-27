import 'package:flutter/material.dart';
import 'package:inventory_app/helper/shared_pref.dart';
import 'package:inventory_app/provider/item_provider.dart';
import 'package:inventory_app/ui/pages/home_page.dart';
import 'package:inventory_app/ui/pages/login_page.dart';
import 'package:inventory_app/ui/pages/search_page.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPref sharedPref = SharedPref();
  bool isLoggedIn = await sharedPref.read('login');
  runApp( MainApp(
    isLoggedIn: isLoggedIn,
  ));
}

class MainApp extends StatelessWidget {
  final bool isLoggedIn;
  const MainApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return  ChangeNotifierProvider(
      create: (context) => ItemProvider(),
      child: MaterialApp(
        home: isLoggedIn ? const HomePage() : const LoginPage(),
        routes: {
          LoginPage.route:(context) => const LoginPage(),
          HomePage.route:(context) => const HomePage(),
          SearchPage.route:(context) => const SearchPage()
        },
      ),
    );
  }
}
