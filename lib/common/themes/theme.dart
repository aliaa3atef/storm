import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:storm/common/colors/colors.dart';

ThemeData darkTheme = ThemeData(
  primarySwatch: basicColor ,
  scaffoldBackgroundColor: Colors.grey[900],
  appBarTheme: AppBarTheme(
    titleSpacing: 20.0,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
    backgroundColor: Colors.grey[800],
    elevation: 0.0,
    titleTextStyle: TextStyle(
      fontFamily: 'Jannah',
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
  ),

  fontFamily: 'Jannah',
    colorScheme: ColorScheme(
      primary:Colors.orange,
      primaryVariant:Colors.orangeAccent,
      secondary: Colors.black26,
      error: Colors.red ,
      onError: Colors.green ,
      onPrimary: Colors.deepOrange ,
      onSurface: Colors.black,
      secondaryVariant: Colors.grey[900] ,
      surface: Colors.white ,
      background: Colors.black,
      onSecondary: Colors.grey[700],
      onBackground:Colors.white,
      brightness:Brightness.light,
    ),
  backgroundColor: Colors.grey[800],
  textTheme: TextTheme(
    headline6: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w700, color: Colors.white, height: 1.3),
    headline5: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700, color:Colors.white , height: 1.3),
    headline4: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400, color:Colors.white , height: 1.3),
    headline3: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700, color:Colors.white , height: 1.3),
    headline2: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700, color:Colors.white , height: 1.4),
    headline1: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w300, color:Colors.white , height: 1.4),
    subtitle2: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600, color:Colors.white , height: 1.2),
    subtitle1: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w400, color:Colors.white , height: 1.2),
    bodyText2: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w600, color:Colors.white , height: 1.2),
    bodyText1: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, color:Colors.white , height: 1.2),
    caption: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w300, color:Colors.grey , height: 1.2),
  ),

);

ThemeData lightTheme = ThemeData(

  textTheme: TextTheme(
    headline6: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w700, color: Colors.black, height: 1.3),
    headline5: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700, color:Colors.black , height: 1.3),
    headline4: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400, color:Colors.black , height: 1.3),
    headline3: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700, color:Colors.black , height: 1.3),
    headline2: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700, color:Colors.black , height: 1.4),
    headline1: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w300, color:Colors.black , height: 1.4),
    subtitle2: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600, color:Colors.black , height: 1.2),
    subtitle1: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w400, color:Colors.black , height: 1.2),
    bodyText2: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w600, color:Colors.black , height: 1.2),
    bodyText1: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, color:Colors.black , height: 1.2),
    caption: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w300, color:Colors.grey , height: 1.2),
  ),
  primarySwatch: basicColor,
  scaffoldBackgroundColor: HexColor('#FCFCFC'),
  appBarTheme: AppBarTheme(
    titleSpacing: 20.0,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
    backgroundColor: Colors.white,
    elevation: 0.0,
    titleTextStyle: TextStyle(
      fontFamily: 'Jannah',
      color: Colors.black,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: basicColor,
    unselectedItemColor: Colors.black54,
    elevation: 20.0,
    backgroundColor: Colors.white,
  ),
  fontFamily: 'Jannah',
  colorScheme: ColorScheme(
    primary:Colors.orange,
    primaryVariant:Colors.orange[300],
    background: Colors.white,
    secondary: Colors.grey[300] ,
    error: Colors.red ,
    onError: Colors.green ,
    onPrimary: Colors.deepOrange ,
    onSurface: Colors.black,
    secondaryVariant: Colors.grey[600] ,
    surface: Colors.white ,
    onSecondary: Colors.grey[800],
    onBackground:Colors.black,
    brightness:Brightness.light,
  ),
  backgroundColor: Colors.white,


);