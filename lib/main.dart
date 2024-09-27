import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:flutter/material.dart';
import 'login-register/login_screen.dart';
import 'add_transaction_screen.dart';
import 'transaction_list_screen.dart';
import 'transaction_model.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'โปรแกรมบันทึกรายรับรายจ่าย',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginScreen(), // เริ่มที่หน้า LoginScreen
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<UserTransaction> _transactions = [];

  void _addTransaction(UserTransaction transaction) {
    setState(() {
      _transactions.add(transaction);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('โปรแกรมบันทึกรายรับรายจ่าย')),
      body: TransactionListScreen(transactions: _transactions),
      // ลบ FloatingActionButton ออก
    );
  }
}
