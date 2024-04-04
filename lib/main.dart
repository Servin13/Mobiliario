import 'package:flutter/material.dart';
import 'package:mobiliario/screens/welcome_screen.dart';
import 'package:mobiliario/screens/furniture_rental_screen.dart';
import 'package:mobiliario/screens/historial_rental_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "welcome",
      routes: {
        "welcome": (context) => WelcomeScreen(),
        "alta": (context) => AltaRentaScreen(),
        "historial": (context) => HistorialRentaScreen(rentas: []),
      },
    );
  }
}
