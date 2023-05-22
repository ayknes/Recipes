import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipes/screens/login.dart';

class AccountPage extends StatefulWidget {
  final User? user;

  AccountPage({this.user});
  @override
  _AccountPageState createState() => _AccountPageState();
  final FirebaseAuth _auth = FirebaseAuth.instance;
}

class _AccountPageState extends State<AccountPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    checkAuthentication();
  }

  void checkAuthentication() async {
    User? user = _auth.currentUser;
    if (user == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
      ),
      body: Center(
        child: user != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('User ID: ${user.uid}'),
                  SizedBox(height: 20),
                  Text('Email: ${user.email}'),
                ],
              )
            : Text('No user signed in.'),
      ),
    );
  }
}
