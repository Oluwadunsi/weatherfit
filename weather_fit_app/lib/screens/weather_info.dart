import 'package:flutter/material.dart';
import 'package:weather_fit_app/models/weather_model.dart';

class WeatherInfo extends StatelessWidget {
  final WeatherModel? weather;
  final AirQuality? airQuality;

  const WeatherInfo({Key? key, required this.weather, required this.airQuality}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mock data
    final String feelsLike = '${weather?.feelsLikeTemperature.round()}°'; // Replace with live data later
    final String locationAirQuality = '${airQuality?.airQualityIndex.toString()}'; // Replace with live data later

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1), // Reduced vertical padding
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Feels like temperature and Air Quality Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCompactInfoCard("Feels like", feelsLike,),
              const SizedBox(height: 6), // Slight spacing between cards
              _buildCompactInfoCard("Air Quality", locationAirQuality),
            ],
          ),
          // Location, Weather Condition, and Temperature Section
          Column(
           // crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(width: 55),
              Container(
                constraints: const BoxConstraints(
                  maxWidth: 200,
                ),
                child: Text(
                      weather?.location ?? "",

                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 4), // Reduced spacing
              Text(
                weather?.weatherCondition ?? "",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 1), // Reduced spacing
              Text(
                  "${weather?.temperature.round() ?? ''}°",
                style: const TextStyle(
                  fontSize: 60,
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
