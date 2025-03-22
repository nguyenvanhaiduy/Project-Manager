import 'package:flutter/material.dart';
import 'package:project_manager/utils/app_constants.dart';

ThemeData lightTheme() => ThemeData.light().copyWith(
      appBarTheme: const AppBarTheme(backgroundColor: kbackgroundLightColor),
      scaffoldBackgroundColor: kbackgroundLightColor,
      textTheme: _textTheme(Colors.black),
      cardTheme: const CardTheme(color: Colors.white),
      elevatedButtonTheme: _buttonTheme(const Color.fromARGB(255, 91, 98, 143)),
      drawerTheme:
          const DrawerThemeData(backgroundColor: kbackgroundLightColor),
      listTileTheme: const ListTileThemeData(
        selectedTileColor: Colors.orange,
        selectedColor: Colors.black,
      ),
      textButtonTheme: _textButtonTheme(Colors.black),
    );

ThemeData darkTheme() => ThemeData.dark().copyWith(
      appBarTheme: const AppBarTheme(backgroundColor: kbackgroundDarkColor),
      scaffoldBackgroundColor: kbackgroundDarkColor,
      textTheme: _textTheme(Colors.white),
      cardTheme: const CardTheme(color: Colors.black54),
      elevatedButtonTheme: _buttonTheme(const Color.fromARGB(255, 31, 57, 111)),
      drawerTheme: const DrawerThemeData(backgroundColor: kbackgroundDarkColor),
      listTileTheme: const ListTileThemeData(
        selectedTileColor: Colors.orange,
        selectedColor: Colors.white,
      ),
      textButtonTheme: _textButtonTheme(Colors.white),
    );

TextTheme _textTheme(Color color) => TextTheme(
      bodyMedium: TextStyle(color: color),
      bodyLarge: TextStyle(color: color),
      bodySmall: TextStyle(color: color),
      titleLarge: TextStyle(color: color),
      titleMedium: TextStyle(color: color),
      titleSmall: TextStyle(color: color),
      headlineLarge: TextStyle(color: color),
    );

ElevatedButtonThemeData _buttonTheme(Color bgColor) => ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateColor.resolveWith((states) => bgColor),
        foregroundColor: WidgetStateColor.resolveWith((states) => Colors.white),
      ),
    );

TextButtonThemeData _textButtonTheme(Color color) => TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateColor.resolveWith((states) => color),
      ),
    );
