import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipes/screens/login.dart';
import 'package:recipes/main.dart';
import 'package:recipes/api/session.dart';

class AccountPage extends StatefulWidget {
  final User? user;

  AccountPage({this.user});

  @override
  _AccountPageState createState() => _AccountPageState();
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

  void signOut() async {
    final AuthService _authService = AuthService();

    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: signOut,
          ),
        ],
      ),
      body: Center(
        child: user != null
            ? Card(
                margin: EdgeInsets.all(20.0),
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: user.photoURL != null
                            ? NetworkImage(user.photoURL!)
                            : AssetImage('assets/images/user_placeholder.png')
                                as ImageProvider,
                        radius: 50,
                      ),
                      SizedBox(height: 20),
                      Text(
                        user.displayName ?? 'No Name',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'User ID: ${user.uid}',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Email: ${user.email}',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
              )
            : Text('No user signed in.'),
      ),
    );
  }
}
