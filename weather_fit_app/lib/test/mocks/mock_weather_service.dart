import 'package:weather_fit_app/services/weather_service.dart';
import 'package:weather_fit_app/models/weather_model.dart';
import 'package:weather_fit_app/models/weather_forecast.dart';

class MockWeatherService extends WeatherService {
  MockWeatherService() : super('mock_api_key');

  static final _mockCoordinates = {
    'valid': {"lat": 40.7128, "lon": -74.0060},
    'invalid': {"lat": 0.0, "lon": 0.0},
  };

  static final _mockWeatherData = {
    'valid': WeatherModel(
      location: 'Test City',
      temperature: 20.0,
      weatherCondition: 'Clear',
      humidity: '45',
      feelsLikeTemperature: 24.5,
      speed: 5.0,
      pressure: 1013,
    ),
  };

  static final _mockForecastData = {
    'valid': WeatherForecast(
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
    ),
  };

  @override
  Future<Map<String, double>> getCoordinates([dynamic params]) async {
    if (params == 'invalid') {
      return _mockCoordinates['invalid']!;
    }
    return _mockCoordinates['valid']!;
  }

  @override
  Future<WeatherModel> getWeather(Map<String, double> coordinate, String cityName) async {
    if (coordinate['lat'] == 0.0 && coordinate['lon'] == 0.0) {
      throw Exception('Invalid coordinates');
    }
    return _mockWeatherData['valid']!;
  }

  @override
  Future<WeatherForecast> dailyForecast(Map<String, double> coordinate) async {
    if (coordinate['lat'] == 0.0 && coordinate['lon'] == 0.0) {
      throw Exception('Invalid forecast request');
    }
    return _mockForecastData['valid']!;
  }

  @override
  Future<AirQuality> airQuality(Map<String, double> coordinate) async {
    if (coordinate['lat'] == 0.0 && coordinate['lon'] == 0.0) {
      throw Exception('Invalid air quality request');
    }
    return AirQuality(airQualityIndex: 2.0); // Mocked data
  }

}
