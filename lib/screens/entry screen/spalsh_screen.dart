import 'package:flutter/material.dart';
import 'package:teleconvo/screens/entry%20screen/welcome_screen.dart';
import 'package:teleconvo/screens/search_screen.dart';
import 'package:teleconvo/services/data%20management/data_management.dart';
import 'package:teleconvo/services/data%20management/stored_string_collection.dart';
import 'package:teleconvo/services/navigation_management.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const id = "splash_screen";
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool spinner = true;
  check() async {
    final userId = await DataManagement.getStringData(StoredString.userAuthId);
    print("USER ID: $userId");
    if (userId == null) {
      Navigation.pushNamedAndReplace(context, WelcomeScreen.id);
    } else {
      Navigation.pushNamedAndReplace(context, SearchScreen.id);
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3)).then((value) async {
      await check();
      spinner = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo3.png',
              height: 500,
              width: 600,
              fit: BoxFit.fitWidth,
            ),
            const Text('TeleConvo',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    color: Colors.blueAccent)),
            const SizedBox(height: 25),
            spinner
                ? const CircularProgressIndicator(color: Colors.white)
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
