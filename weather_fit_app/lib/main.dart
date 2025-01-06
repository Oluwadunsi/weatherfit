import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weather_fit_app/screens/weather_home_page.dart';
import 'package:weather_fit_app/services/weather_service.dart';
import 'package:weather_fit_app/test/mocks/mock_weather_service.dart';

void main({MockWeatherService? service}) {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
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
