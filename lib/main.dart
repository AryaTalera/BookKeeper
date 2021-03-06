import 'package:book_keeper/screens/transactions_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const TransactionsScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
