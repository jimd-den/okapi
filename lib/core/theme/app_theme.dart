import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get darkTheme => ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.greenAccent,
      titleTextStyle: TextStyle(
        color: Colors.greenAccent,
        fontSize: 22,
        fontFamily: 'monospace',
      ),
      centerTitle: true,
      elevation: 0,
      toolbarHeight: 70,
      shape: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        fontSize: 16,
        color: Colors.greenAccent,
        fontFamily: 'monospace',
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.greenAccent,
        fontFamily: 'monospace',
      ),
      labelLarge: TextStyle(
        color: Colors.greenAccent,
        fontWeight: FontWeight.bold,
        fontFamily: 'monospace',
        fontSize: 16,
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(
        color: Colors.lightGreenAccent,
        fontFamily: 'monospace',
      ),
      hintStyle: TextStyle(color: Colors.grey, fontFamily: 'monospace'),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.greenAccent),
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.redAccent),
      ),
    ),
  );
}
