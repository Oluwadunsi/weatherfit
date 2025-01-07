import 'package:flutter/material.dart';
import 'package:weather_fit_app/models/weather_model.dart';

class BottomSection extends StatelessWidget {
  final WeatherModel? weather;

  const BottomSection({Key? key, required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int visibility = weather?.visibility ?? 0;

  final dataItems = [
      {"title": "Wind Speed", "value": "${weather?.speed} km/h"},
      {"title": "Humidity", "value": "${weather?.humidity ?? '0'}%"},
      {"title": "Pressure", "value": "${weather?.pressure ?? 0} hPa"},
      {"title": "Visibility", "value": "${(visibility * 0.0001).round()} km"},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Wrap(
            spacing: 16, // Space between components horizontally
            runSpacing: 16, // Space between rows vertically
            children: dataItems.map((item) {
              final width = (constraints.maxWidth / 2) - 20; // Ensure two items per row
              return SizedBox(
                width: width,
                child: _buildDataCard(item["title"]!, item["value"]!),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Widget _buildDataCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
