import 'package:flutter/material.dart';
import 'package:ociuz_task/theme/appbar_theme.dart';
import 'package:ociuz_task/theme/text_theme.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    appBarTheme: KAppbarTheme.lightAppBarTheme,
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    textTheme: KTextTheme.lightTextTheme,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
  static ThemeData darkTheme = ThemeData(
    appBarTheme: KAppbarTheme.darkAppBarTheme,
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: Colors.black,
    scaffoldBackgroundColor: Colors.black,
    textTheme: KTextTheme.darkTextTheme,
  );
}
