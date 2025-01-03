import 'package:flutter/material.dart';
import 'package:weather_fit_app/models/weather_model.dart';
import 'package:weather_fit_app/models/weather_forecast.dart';
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
  WeatherForecast? _forecast;
  AirQuality? _airQualityIndex;
  String _cityInput = "";
  String _currentLocation = "New York";

  @override
  void initState() {
    super.initState();
    _getWeather();
    _dailyForecast();
    _airQuality();
  }

  Future<void> _getWeather() async {
    try {
      final Map<String, double> coordinates = await _weatherService.getCoordinates(_cityInput);
      final currentWeather = await _weatherService.getWeather(
        coordinates,
        _cityInput,
      );
      setState(() {
        _weather = currentWeather;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _dailyForecast() async {
    try {
      final Map<String, double> coordinates = await _weatherService.getCoordinates(_cityInput);
      final forecast = await _weatherService.dailyForecast(coordinates);
      setState(() {
        _forecast = forecast;
      });
    }
    catch (e) {}
  }

  Future<void> _airQuality() async {
    try {
      final Map<String, double> coordinates = await _weatherService.getCoordinates(_cityInput);
      final airQuality = await _weatherService.airQuality(coordinates);
      setState(() {
        _airQualityIndex = airQuality;
      });
    }
    catch (e) {}
  }



  void searchIconPressed() {
    _cityInput = _searchLocation.text;
    _searchLocation.clear();
    _getWeather();
    _airQuality();
    _dailyForecast();
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
                      onSearchPressed: searchIconPressed,
                      onSearchSubmit: (value) {
                        setState(() => _cityInput = _searchLocation.text);
                        _getWeather();
                        _dailyForecast();
                        _airQuality();
                        _searchLocation.clear();
                      },
                    ),
                    const SizedBox(height: 20),
                    WeatherInfo(weather: _weather, airQuality: _airQualityIndex),
                    const SizedBox(height: 20),
                    OutfitSuggestion(
                      temperature: _weather?.temperature ?? 20.5,
                      weatherCondition: _weather?.weatherCondition ?? "clear",
                    ),
                    const SizedBox(height: 20),
                    UpcomingDays(forecast: _forecast),
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
