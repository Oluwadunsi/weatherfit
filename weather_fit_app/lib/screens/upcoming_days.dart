import 'package:flutter/material.dart';
import 'package:weather_fit_app/models/weather_forecast.dart';

class UpcomingDays extends StatelessWidget {
  final WeatherForecast? forecast;

  UpcomingDays({Key? key, required this.forecast}) : super(key: key);

  final List<String> day = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
  final DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Upcoming Days",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 120, // Adjusted height to prevent overflow
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5, // Number of forecast days
            itemBuilder: (context, index) {

              // Check if forecast or required data is null
              if (forecast?.tempList == null ||
                  forecast?.tempList['list'] == null ||
                  index * 8 >= (forecast?.tempList['list']?.length ?? 0)) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      "No Data",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ),
                );
              }

              final dayName = day[(now.weekday - 1 + index) % 7]; // Safely calculate the day
              final tempData = forecast?.tempList['list'][index * 8]; // Avoid invalid index access
              final temp = tempData?['main']?['temp'];
              final weatherIcon = tempData?['weather']?[0]?['icon'];


              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Safely display the day
                    Text(
                      dayName,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    // Safely display the weather icon
                    if (weatherIcon != null)
                      Image.network(
                        'http://openweathermap.org/img/w/$weatherIcon.png',
                        width: 40,
                        height: 20,
                      )
                    else
                      const Icon(Icons.error, size: 20, color: Colors.red),
                    const SizedBox(height: 8),
                    // Safely display the temperature
                    Text(
                      temp != null
                          ? '${temp.toDouble().round()}°'
                          : 'N/A', // Fallback for missing data
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
