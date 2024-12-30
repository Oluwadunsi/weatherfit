import 'package:flutter/material.dart';
import 'package:weather_fit_app/models/weather_model.dart';
import 'package:weather_fit_app/services/weather_service.dart';
import 'package:weather_fit_app/screens/favorite_locations_page.dart';

// Import your newly created widgets
import 'top_section.dart';
import 'weather_info.dart';
import 'outfit_suggestion.dart';
import 'hourly_forecast.dart';
import 'upcoming_days.dart';
import 'bottom_section.dart';

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({Key? key}) : super(key: key);

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  final _weatherService = WeatherService('3df683afc2a8c5ffaad3c79a3cebe230');
  final TextEditingController _searchLocation = TextEditingController();
  final ValueNotifier<List<String>> _favoriteLocations = ValueNotifier([]);
  WeatherModel? _weather;
  String _cityInput = "";
  String _currentLocation = "New York";

  @override
  void initState() {
    super.initState();
    _getWeather();
  }

  Future<void> _getWeather() async {
    String postalCode = await _weatherService.getPostalCode();
    String countryCode = await _weatherService.getCountryCode();
    try {
      final currentWeather = await _weatherService.getWeather(postalCode, countryCode, _cityInput);
      setState(() => _weather = currentWeather);
    } catch (e) {
      print(e);
    }
  }

  // Mock hourly data
  List<Map<String, String>> _getHourlyData() {
    return List.generate(12, (index) {
      final hour = DateTime.now().add(Duration(hours: index));
      return {
        "time": "${hour.hour % 12 == 0 ? 12 : hour.hour % 12} ${hour.hour >= 12 ? 'PM' : 'AM'}",
        "temp": "${20 + index}°C", // Example temperature
        "icon": "sunny", // Placeholder for weather condition
      };
    });
  }

  // Determine background image
  String _getBackgroundImage(String condition) {
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
  void dispose() {
    _favoriteLocations.dispose();
    _searchLocation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hourlyData = _getHourlyData();
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
                    favoriteLocations: _favoriteLocations,
                    onRemove: (location) {
                      _favoriteLocations.value.remove(location);
                      _favoriteLocations.notifyListeners();
                    },
                  ),
                ),
              );
            },
            child: const Text("Favorites", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background image
          Image.asset(
            _getBackgroundImage(currentCondition),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
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
                    TopSection(
                      favoriteLocations: _favoriteLocations,
                      currentLocation: _currentLocation,
                      searchLocation: _searchLocation,
                      onSearchPressed: _getWeather,
                      onSearchSubmit: (value) {
                        setState(() => _cityInput = _searchLocation.text);
                        _getWeather();
                        _searchLocation.clear();
                      },
                    ),
                    const SizedBox(height: 20),

                    // Weather Info
                    WeatherInfo(weather: _weather),
                    const SizedBox(height: 20),

                    // Outfit Suggestion
                    const OutfitSuggestion(),
                    const SizedBox(height: 20),

                    // Hourly Forecast
                    HourlyForecast(hourlyData: hourlyData),
                    const SizedBox(height: 20),

                    // Upcoming Days
                    const UpcomingDays(),
                    const SizedBox(height: 20),

                    // Bottom Section with Additional Info
                    BottomSection(weather: _weather),
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
