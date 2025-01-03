import 'package:flutter/material.dart';
import 'package:weather_fit_app/models/weather_forecast.dart';

class UpcomingDays extends StatelessWidget {
  final WeatherForecast? forecast;

  UpcomingDays({Key? key, required this.forecast}) : super(key: key);

  final List<String> day = ["Mon", "Tue", "Wed", "Thur", "Fri", "Sat", "Sun"];
  final now = DateTime.now();

  List<String> temp = [];
  upcoming() async {
    Map<String, dynamic>? upcomingDay = forecast?.tempList;
    temp = upcomingDay?['list'][0]['weather'][0]['main'];
    int len = upcomingDay?['list'].toLength();

    for(int i = 0; i < 4; i++) {
      temp.add(upcomingDay?['list'][i]['sys']['dt_txt']);
    }
  }

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
                    // Fix is here: use modulo to avoid out-of-range
                    Text(
                      day[(now.weekday - 1 + index) % 7], // start from the current day
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Image.network(
                      'http://openweathermap.org/img/w/${forecast?.tempList['list'][index*8]['weather'][0]['icon']}.png',
                      width: 40,
                      height: 20,
                    ),
                    const SizedBox(height: 8),
                    // upcoming weather from today to the next 4 days
                    Text('${forecast?.tempList['list'][index * 8]['main']['temp'].round()}°', style: TextStyle(fontSize: 14)),
                  ],
                )
              );
            },
          ),
        ),
      ],
    );
  }
}
