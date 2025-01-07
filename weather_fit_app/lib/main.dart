import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_fit_app/screens/weather_home_page.dart';
import 'package:weather_fit_app/services/weather_service.dart';
import 'package:weather_fit_app/test/mocks/mock_weather_service.dart';

void main({MockWeatherService? service}) async{
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  final WeatherService? service;

  const MyApp({Key? key, this.service}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      behavior: HitTestBehavior.opaque,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Poppins'),
        home: WeatherHomePage(service: service),
      ),
    );
  }
}
