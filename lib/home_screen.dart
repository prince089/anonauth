import 'package:anonauth/login_screen.dart';
import 'package:anonauth/register_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _initializeUserDocument();
  }

  Future<void> _initializeUserDocument() async {
    User? user = _auth.currentUser;
    // if (user != null) {
    //   // Create or update document with initial counter
    //   await _firestore.collection('users').doc(user.uid).set({
    //     'counter': FieldValue,
    //   }, SetOptions(merge: true));
    // }
  }

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        actions: [
          IconButton(
            icon: Icon(Icons.login),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.app_registration),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegisterScreen()),
              );
            },
          ),
        ],
      ),
      body: user != null
          ? StreamBuilder<DocumentSnapshot>(
              stream: _firestore.collection('users').doc(user.uid).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading data'));
                }

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                // int counter = snapshot.data!['counter'] ?? 0;

                return Center(
                  child: Text(
                    'Count: ${user.uid}',
                    style: const TextStyle(fontSize: 24),
                  ),
                );
              },
            )
          : const Center(child: Text('No User Found')),
    );
  }
}
