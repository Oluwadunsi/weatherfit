import 'package:flutter/material.dart';
import 'package:weather_fit_app/models/weather_model.dart';

class WeatherInfo extends StatelessWidget {
  final WeatherModel? weather;

  const WeatherInfo({Key? key, required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mock data
    final String mockUvIndex = "Moderate"; // Replace with live data later
    final String mockAirQuality = "Fair"; // Replace with live data later

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8), // Reduced vertical padding
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // UV Index and Air Quality Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCompactInfoCard("UV Index", mockUvIndex),
              const SizedBox(height: 6), // Slight spacing between cards
              _buildCompactInfoCard("Air Quality", mockAirQuality),
            ],
          ),
          // Location, Weather Condition, and Temperature Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                weather?.location ?? "N/A",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4), // Reduced spacing
              Text(
                weather?.weatherCondition ?? "N/A",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 1), // Reduced spacing
              Text(
                "${weather?.temperature.round() ?? 'N/A'}°",
                style: const TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper method for compact UV and Air Quality cards
  Widget _buildCompactInfoCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 6), // Reduced padding
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 2), // Reduced spacing
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
