import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CounterScreen extends StatefulWidget {
  final String username;

  CounterScreen({required this.username});

  @override
  _CounterScreenState createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int _counter = 0;
  late FirebaseFirestore _firestore;

  @override
  void initState() {
    super.initState();
    _firestore = FirebaseFirestore.instance;
    _loadCounter();
  }

  // Load counter value from Firestore for the current user
  void _loadCounter() async {
    DocumentSnapshot doc =
        await _firestore.collection('users').doc(widget.username).get();

    if (doc.exists) {
      setState(() {
        _counter = doc['counter'] ?? 0;
      });
    }
  }

  // Increment counter value and update Firestore
  void _incrementCounter() async {
    setState(() {
      _counter++;
    });

    await _firestore.collection('users').doc(widget.username).set({
      'counter': _counter,
    }, SetOptions(merge: true));  // Merge to prevent overwriting other fields
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Welcome, ${widget.username}")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Counter: $_counter",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _incrementCounter,
              child: Text("Increment"),
            ),
          ],
        ),
      ),
    );
  }
}
