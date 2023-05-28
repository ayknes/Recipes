import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:recipes/screens/search.dart';
import 'package:recipes/screens/saved.dart';
import 'package:recipes/screens/account.dart';
import 'package:recipes/api/session.dart';
import 'package:recipes/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'components/nav_bottom.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyBLTvOIHnHEJ-bxxRxkzjUz58nV7TRa4XE",
        authDomain: "recipes-6af77.firebaseapp.com",
        projectId: "recipes-6af77",
        storageBucket: "recipes-6af77.appspot.com",
        messagingSenderId: "501561779332",
        appId: "1:501561779332:web:9ffd4056116d879fc30ed1",
        measurementId: "G-WPGVKSNTEC"),
  );
  runApp(RecipeSearchApp());
}

class RecipeSearchApp extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Search',
      theme: ThemeData(primarySwatch: Colors.red),
      home: MainScreen(authService: _authService),
    );
  }
}

class MainScreen extends StatefulWidget {
  final AuthService authService;

  MainScreen({required this.authService});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _commonScreens = [
    SearchScreen(),
    SavedScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: widget.authService.user,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          Widget userScreen;
          if (user == null) {
            userScreen = LoginPage();
          } else {
            userScreen = AccountPage(user: user);
          }

          List<Widget> _screens = [..._commonScreens, userScreen];

          return Scaffold(
            body: _screens[_selectedIndex],
            bottomNavigationBar: CustomBottomNavigation(
              onTap: _onItemSelected,
            ),
          );
        } else {
          // Show some loading screen or widget until the user state is known
          return CircularProgressIndicator();
        }
      },
    );
  }

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
