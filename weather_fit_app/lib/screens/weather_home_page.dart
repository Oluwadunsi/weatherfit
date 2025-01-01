import 'package:flutter/material.dart';
import 'package:weather_fit_app/models/weather_model.dart';
import 'package:weather_fit_app/services/weather_service.dart';
import 'package:weather_fit_app/screens/favorite_locations_page.dart';

// Import your widgets
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
    try {
      final currentWeather = await _weatherService.getWeather(
        "10001", // Mock postal code
        "US", // Mock country code
        _cityInput,
      );
      setState(() {
        _weather = currentWeather;
      });
    } catch (e) {
      print(e);
    }
  }

  String _getBackgroundImage(String? condition) {
    switch (condition?.toLowerCase()) {
      case "clear":
        return "assets/clear.jpg";
      case "rain":
        return "assets/rainy.jpg";
      case "clouds":
        return "assets/cloudy.jpg";
      case "snow":
        return "assets/snowy.jpg";
      default:
        return "assets/clear.jpg";
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentCondition = _weather?.weatherCondition ?? "clear";

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
          // Background image with overlay
          Stack(
            children: [
              Image.asset(
                _getBackgroundImage(currentCondition),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
              Container(
                color: Colors.black.withOpacity(0.4),
              ),
            ],
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
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
                    WeatherInfo(weather: _weather),
                    const SizedBox(height: 20),
                    OutfitSuggestion(
                      temperature: _weather?.temperature ?? 20.5,
                      weatherCondition: _weather?.weatherCondition ?? "clear",
                    ),
                    const SizedBox(height: 20),
                    UpcomingDays(),
                    const SizedBox(height: 20),
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
