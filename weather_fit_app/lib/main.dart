import 'package:flutter/material.dart';
import 'package:weather_fit_app/services/weather_service.dart';
import 'package:weather_fit_app/screens/weather_home_page.dart';

void main({WeatherService? service}) {
  runApp(MyApp(service: service));
}

class MyApp extends StatelessWidget {
  final WeatherService? service;

  const MyApp({Key? key, this.service}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WeatherHomePage(service: service),
    );
  }
}
