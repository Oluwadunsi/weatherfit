import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weather_fit_app/bloc/app_state.dart';
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

class WeatherHomePage extends ConsumerStatefulWidget {
  const WeatherHomePage({super.key, this.city});

  final String? city;

  @override
  ConsumerState<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends ConsumerState<WeatherHomePage> {
  final _weatherService = WeatherService('3df683afc2a8c5ffaad3c79a3cebe230');
  final TextEditingController _searchLocation = TextEditingController();
  WeatherModel? _weather;
  WeatherForecast? _forecast;
  AirQuality? _airQualityIndex;
  String _cityInput = "";
  String _currentLocation = "";
  Map<String, double>? location;

  @override
  void initState() {
    super.initState();
    if(widget.city == null) initialize();
    if(widget.city != null) searchIconPressed(initial: widget.city);
  }

  Future<void> initialize() async {
    await _weatherService.getLocationPermission(
      onLocationPermitted: (loc) async {
        setState(() {
          location = loc;
        });

        await _getWeather();
        await _dailyForecast();
        await _airQuality();
      },
      onLocationRejected: () {
        setState(() {});
      },
    );
  }

  Future<void> _getWeather() async {
    if (location == null) return;
    final Map<String, double> coordinates =
        await _weatherService.getCoordinates(_cityInput) ?? location!;

    final currentWeather = await _weatherService.getWeather(
      coordinates,
      _cityInput,
    );
    setState(() {
      _weather = currentWeather;
      _currentLocation = _weather?.location ?? 'n/a';
    });
  }

  Future<void> _dailyForecast() async {
    if (location == null) return;
    try {
      final Map<String, double> coordinates =
          await _weatherService.getCoordinates(_cityInput) ?? location!;
      final forecast = await _weatherService.dailyForecast(coordinates);
      setState(() {
        _forecast = forecast;
      });
    } catch (e) {}
  }

  Future<void> _airQuality() async {
    if (location == null) return;
    try {
      final Map<String, double> coordinates =
          await _weatherService.getCoordinates(_cityInput) ?? location!;
      final airQuality = await _weatherService.airQuality(coordinates);
      setState(() {
        _airQualityIndex = airQuality;
      });
    } catch (e) {}
  }

  Future<void> searchIconPressed({String? initial}) async {
    _cityInput = initial ?? _searchLocation.text.trim();
    _currentLocation = _cityInput;
    _searchLocation.clear();
    await initialize();
  }

  String _getBackgroundImage(String? condition) {
    switch (condition?.toLowerCase()) {
      case "clear":
        return "assets/clear.jpg";
      case "rain":
        return "assets/rainy.jpeg";
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
    var app = ref.watch(appState);
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
                  builder: (context) => const FavoriteLocationsPage(),
                ),
              );
            },
            child:
                const Text("Favorites", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: location == null
          ? ListView(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              children: const [
                Text(
                  "Loading...",
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            )
          : Stack(
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
                            favoriteLocations: app.favourites,
                            currentLocation: _currentLocation,
                            searchLocation: _searchLocation,
                            onSearchPressed: () async => await searchIconPressed(),
                            onSearchSubmit: (value) {
                              setState(() => _cityInput = _searchLocation.text);
                              _getWeather();
                              _dailyForecast();
                              _airQuality();
                              _searchLocation.clear();
                            },
                            onFavouriteChanged: (value) {
                              if(value) {
                                app.removeFavourite(_currentLocation);
                              } else {
                                app.addFavourite = _currentLocation;
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          WeatherInfo(
                              weather: _weather, airQuality: _airQualityIndex),
                          const SizedBox(height: 20),
                          OutfitSuggestion(
                            temperature: _weather?.temperature ?? 20.5,
                            weatherCondition:
                                _weather?.weatherCondition ?? "clear",
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
