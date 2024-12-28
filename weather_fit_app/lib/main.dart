import 'package:flutter/material.dart';
import 'favorite_locations_page.dart';
import 'package:weather_fit_app/models/weather_model.dart';
import 'package:weather_fit_app/services/weather_service.dart';

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
  final _weatherService = WeatherService('3df683afc2a8c5ffaad3c79a3cebe230');
  WeatherModel? _weather;

  _getWeather() async {
    String postalCode = await _weatherService.getPostalCode();
    String countryCode = await _weatherService.getCountryCode();

    try {
      final currentWeather = await _weatherService.getWeather(postalCode, countryCode);
      setState(() {
        _weather = currentWeather;
      });
    }
    catch (e) {
      print(e);
    }
  }

  final ValueNotifier<List<String>> favoriteLocations = ValueNotifier([]);
  //String currentLocation = _weather?.location ?? "loading location..";
  String currentLocation = "New York";
  @override
  void dispose() {
    favoriteLocations.dispose();
    super.dispose();

  }


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
  void initState() {
    super.initState();

    _getWeather();
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
                  builder: (context) => FavoriteLocationsPage(
                    favoriteLocations: favoriteLocations,
                    onRemove: (location) {
                      favoriteLocations.value.remove(location);
                      favoriteLocations.notifyListeners();
                    },
                  ),
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
                        ValueListenableBuilder<List<String>>(
                          valueListenable: favoriteLocations,
                          builder: (context, favorites, child) {
                            final isFavorited = favorites.contains(currentLocation);
                            return IconButton(
                              icon: Icon(
                                isFavorited ? Icons.favorite : Icons.favorite_border,
                                color: isFavorited ? Colors.red : null,
                              ),
                              onPressed: () {
                                if (isFavorited) {
                                  favorites.remove(currentLocation);
                                } else {
                                  favorites.add(currentLocation);
                                }
                                favoriteLocations.notifyListeners();
                              },
                            );
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
                          _weather?.location ?? "loading location",
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 10),
                        Text('${_weather?.temperature.round()}°' ?? '',
                          style: TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text('${_weather?.weatherCondition}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'UV Index: Low',
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
                                '${_weather?.humidity}%', //humidity set
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
