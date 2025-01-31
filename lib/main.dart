
// ignore_for_file: prefer_const_constructors

import 'package:bible_assistant/read_bible.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MaterialApp(home: ReadBible()),
    );
  }
}
