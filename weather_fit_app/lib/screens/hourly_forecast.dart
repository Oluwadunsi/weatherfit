// import 'package:flutter/material.dart';
//
// class HourlyForecast extends StatelessWidget {
//   final List<Map<String, String>> hourlyData;
//
//   const HourlyForecast({Key? key, required this.hourlyData}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "Hourly Forecast",
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 10),
//         SizedBox(
//           height: 100,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: hourlyData.length,
//             itemBuilder: (_, index) {
//               final hour = hourlyData[index];
//               return Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 8),
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Colors.blue[100],
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(hour["time"]!, style: const TextStyle(fontSize: 14)),
//                     const SizedBox(height: 8),
//                     const Icon(Icons.wb_sunny), // Replace with real icons
//                     const SizedBox(height: 8),
//                     Text(hour["temp"]!, style: const TextStyle(fontSize: 14)),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
