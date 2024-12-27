import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WeatherHomePage(),
    );
  }
}

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({Key? key}) : super(key: key);

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  List<String> favoriteLocations = [];
  String currentLocation = "New York, USA";

  // Mock hourly data
  List<Map<String, String>> getHourlyData() {
    return List.generate(12, (index) {
      final hour = DateTime.now().add(Duration(hours: index));
      return {
        "time": "${hour.hour % 12 == 0 ? 12 : hour.hour % 12} ${hour.hour >= 12 ? 'PM' : 'AM'}",
        "temp": "${20 + index}°C", // Example temperature
        "icon": "sunny", // Placeholder for weather condition
      };
    });
  }

  // Get background image based on weather condition
  String getBackgroundImage(String condition) {
    switch (condition) {
      case "sunny":
        return "assets/sunny.jpg";
      case "rainy":
        return "assets/rainy.jpg";
      case "cloudy":
        return "assets/cloudy.jpg";
      default:
        return "assets/clear.jpg";
    }
  }

  @override
  Widget build(BuildContext context) {
    final hourlyData = getHourlyData();
    final currentCondition = "sunny"; // Replace with real condition dynamically

    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather Styles"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoriteLocationsPage(favoriteLocations: favoriteLocations),
                ),
              );
            },
            child: const Text(
              "Favorites",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background image based on weather condition
          Image.asset(
            getBackgroundImage(currentCondition),
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),

          // Foreground content
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Top Section
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            favoriteLocations.contains(currentLocation)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: favoriteLocations.contains(currentLocation) ? Colors.red : null,
                          ),
                          onPressed: () {
                            setState(() {
                              if (favoriteLocations.contains(currentLocation)) {
                                favoriteLocations.remove(currentLocation);
                              } else {
                                favoriteLocations.add(currentLocation);
                              }
                            });
                          },
                        ),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              hintText: "Search location",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Weather Information
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          currentLocation,
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "27°C",
                          style: TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "UV Index: Moderate",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Air Quality: Good",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Outfit Suggestion
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "Outfit Suggestion: Wear a light T-shirt and sunglasses.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Hourly Forecast Section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hourly Forecast",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: hourlyData.length,
                            itemBuilder: (context, index) {
                              final hour = hourlyData[index];
                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 8),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.blue[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      hour["time"]!,
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    SizedBox(height: 8),
                                    Icon(Icons.wb_sunny), // Replace with real icons
                                    SizedBox(height: 8),
                                    Text(
                                      hour["temp"]!,
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Upcoming Days Forecast Section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Upcoming Days",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
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
                                    Text(
                                      "Day ${index + 1}",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    SizedBox(height: 8),
                                    Icon(Icons.wb_cloudy, size: 24),
                                    SizedBox(height: 8),
                                    Text(
                                      "25°C",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Bottom Section with Additional Information
                    Container(
                      height: 150,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Wind Speed",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "10 km/h",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Humidity",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "65%",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Pressure",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "1013 hPa",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FavoriteLocationsPage extends StatelessWidget {
  final List<String> favoriteLocations;

  const FavoriteLocationsPage({Key? key, required this.favoriteLocations}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorite Locations"),
        backgroundColor: Colors.blue,
      ),
      body: favoriteLocations.isEmpty
          ? Center(
        child: Text(
          "No favorite locations added yet.",
          style: TextStyle(fontSize: 18),
        ),
      )
          : ListView.builder(
        itemCount: favoriteLocations.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(favoriteLocations[index]),
          );
        },
      ),
    );
  }
}
