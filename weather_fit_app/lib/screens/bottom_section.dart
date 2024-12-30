import 'package:flutter/material.dart';
import 'package:weather_fit_app/models/weather_model.dart';

class BottomSection extends StatelessWidget {
  final WeatherModel? weather;

  const BottomSection({Key? key, required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildColumn("Wind Speed", "10 km/h"),
          _buildColumn("Humidity", "${weather?.humidity}%"),
          _buildColumn("Pressure", "1013 hPa"),
        ],
      ),
    );
  }

  Widget _buildColumn(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        Text(value, style: const TextStyle(fontSize: 16, color: Colors.white)),
      ],
    );
  }
}
