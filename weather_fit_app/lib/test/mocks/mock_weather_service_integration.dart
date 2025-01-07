import 'dart:ui';
import 'package:weather_fit_app/models/weather_model.dart';
import 'package:weather_fit_app/models/weather_forecast.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
import 'mock_weather_service.dart';

class MockWeatherServiceIntegration extends MockWeatherService  {
  MockWeatherServiceIntegration() : super();

  static final _mockCoordinates = {
    'valid': {"lat": 40.7128, "lon": -74.0060}, // New York City
    'invalid': {"lat": 0.0, "lon": 0.0},
  };

  static final _mockWeatherData = {
    'valid': WeatherModel(
      location: 'New York',
      temperature: 25.0,
      weatherCondition: 'Clouds',
      humidity: '50',
      feelsLikeTemperature: 27.0,
      speed: 10.0,
      pressure: 1015, visibility: 1,
    ),
  };

  @override
  Future<Map<String, double>> getCoordinates([dynamic params]) async {
    if (params == 'Invalid City') {
      return _mockCoordinates['invalid']!;
    }
    return _mockCoordinates['valid']!;
  }

  @override
  Future<WeatherModel> getWeather(Map<String, double> coordinate, String cityName) async {
    if (coordinate['lat'] == 0.0 && coordinate['lon'] == 0.0) {
      throw Exception('Invalid coordinates for city: $cityName');
    }
    return _mockWeatherData['valid']!;
  }

  @override
  Future<WeatherForecast> dailyForecast(Map<String, double> coordinate) async {
    if (coordinate['lat'] == 0.0 && coordinate['lon'] == 0.0) {
      throw Exception('Invalid forecast request');
    }
    return WeatherForecast(
      temperature: 22.0,
      tempList: {
        'list': [
          {
            'main': {'temp': 18.0},
            'weather': [{'icon': '01n'}],
            'dt_txt': '2025-01-04 21:00:00',
          },
          {
            'main': {'temp': 20.5},
            'weather': [{'icon': '10d'}],
            'dt_txt': '2025-01-05 09:00:00',
          },
        ],
      },
    );
  }

  @override
  Future<void> getLocationPermission({
    Future Function(Map<String, double>)? onLocationPermitted,
    VoidCallback? onLocationRejected,
  }) async {
    const mockLocation = {"lat": 40.7128, "lon": -74.0060}; // Mocked location (New York City)
    await Future.delayed(const Duration(milliseconds: 100)); // Ensure async behavior
    if (onLocationPermitted != null) {
      await onLocationPermitted(mockLocation); // Simulate granting permission
    }
  }
}

class MockGeolocatorPlatformIntegration extends GeolocatorPlatform {
  @override
  Future<LocationPermission> checkPermission() async {
    return LocationPermission.always;
  }

  @override
  Future<LocationPermission> requestPermission() async {
    return LocationPermission.always;
  }

  @override
  Future<Position> getCurrentPosition({LocationSettings? locationSettings}) async {
    return Position(
      longitude: -74.0060,
      latitude: 40.7128,
      timestamp: DateTime.now(),
      accuracy: 5.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
      altitudeAccuracy: 0.0,
      headingAccuracy: 0.0,
    );
  }
}
