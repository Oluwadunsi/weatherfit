import 'package:flutter/material.dart';

class UpcomingDays extends StatelessWidget {
  const UpcomingDays({Key? key}) : super(key: key);

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
                    Text("Day ${index + 1}", style: const TextStyle(fontSize: 14)),
                    const SizedBox(height: 8),
                    const Icon(Icons.wb_cloudy, size: 24),
                    const SizedBox(height: 8),
                    const Text("25°C", style: TextStyle(fontSize: 14)),
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
