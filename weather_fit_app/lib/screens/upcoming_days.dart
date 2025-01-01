import 'package:flutter/material.dart';
import 'package:weather_fit_app/models/weather_model.dart';

class UpcomingDays extends StatelessWidget {
  //final WeatherForecast? forecast;
  UpcomingDays({Key? key}) : super(key: key);

  List<String> day = ["Mon", "Tue", "Wed", "Thur", "Fri", "Sat", "Sun"];
  var now = DateTime.now();


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
            itemCount: 7, // Number of forecast days
            itemBuilder: (context, index) {
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
                    Text(" ${ day[now.weekday + index]}", style: const TextStyle(fontSize: 14)),
                    const SizedBox(height: 8),
                    const Icon(Icons.wb_cloudy, size: 24),
                    const SizedBox(height: 8),
                    Text('0 C', style: TextStyle(fontSize: 14)),
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
