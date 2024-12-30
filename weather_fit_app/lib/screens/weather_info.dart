import 'package:flutter/material.dart';
import 'package:weather_fit_app/models/weather_model.dart';

class WeatherInfo extends StatelessWidget {
  final WeatherModel? weather;

  const WeatherInfo({Key? key, required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          weather?.location ?? 'loading location',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 10),
        Text(
          '${weather?.weatherCondition}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        Text(
          '${weather?.temperature.round()}°',
          style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 10),
        const Text(
          'UV Index: Low',
          style: TextStyle(fontSize: 18, color: Colors.black54),
        ),
        const SizedBox(height: 10),
        const Text(
          "Air Quality: Good",
          style: TextStyle(fontSize: 18, color: Colors.black54),
        ),
      ],
    );
  }
}
