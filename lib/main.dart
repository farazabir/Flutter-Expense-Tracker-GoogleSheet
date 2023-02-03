import 'package:expense_tracker/googleSheet.dart';
import 'package:expense_tracker/homepage.dart';
import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';


void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleSheetsApi().init();
  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(child:HomePage()),
    );
  }
}
