import 'package:flutter_test/flutter_test.dart';
import '../mocks/mock_weather_service.dart';


void main() {
  late MockWeatherService mockWeatherService;

  setUp(() {
    mockWeatherService = MockWeatherService();
  });

  group('WeatherService Tests', () {
    // Test for fetching weather with coordinates
    test('Should return weather data for valid coordinates', () async {
      final coordinates = await mockWeatherService.getCoordinates();
      final weather = await mockWeatherService.getWeather(coordinates, '');
      expect(weather.location, equals('Test City'));
      expect(weather.temperature, equals(20.0));
      expect(weather.weatherCondition, equals('Clear'));
      expect(weather.humidity, equals('45'));
      expect(weather.feelsLikeTemperature, equals(24.5));
      expect(weather.speed, equals(5.0)); // Test wind speed
      expect(weather.pressure, equals(1013)); // Test pressure
    });


    // Test for fetching weather with a city name
    test('Should return weather data for a valid city name', () async {
      final weather = await mockWeatherService.getWeather({}, 'Test City');
      expect(weather.location, equals('Test City'));
      expect(weather.weatherCondition, equals('Clear'));
    });

    // Test for air quality data
    test('Should return air quality data for valid coordinates', () async {
      final coordinates = await mockWeatherService.getCoordinates();
      final airQuality = await mockWeatherService.airQuality(coordinates);
      expect(airQuality.airQualityIndex, equals(2.0)); // Mock AQI value
    });

    // Test for daily forecast
    test('Should return daily forecast data for valid coordinates', () async {
      final coordinates = await mockWeatherService.getCoordinates();
      final forecast = await mockWeatherService.dailyForecast(coordinates);
      expect(forecast.temperature, equals(22.0));
      expect(forecast.tempList['list'][0]['main']['temp'], equals(18.0));
    });

    // Test for invalid coordinates
    test('Should handle invalid coordinates gracefully', () async {
      final coordinates = {"lat": 0.0, "lon": 0.0}; // Simulate invalid coordinates
      expect(() async => await mockWeatherService.getWeather(coordinates, ''),
          throwsA(isA<Exception>()));
    });

    // Test for invalid city name
    test('Should handle invalid city name gracefully', () async {
      final weather = await mockWeatherService.getWeather({}, '');
      expect(weather.weatherCondition, equals('Clear')); // Default mock condition
    });

    // Test for invalid air quality request
    test('Should handle invalid air quality request gracefully', () async {
      final coordinates = {"lat": 0.0, "lon": 0.0}; // Simulate invalid coordinates
      expect(() async => await mockWeatherService.airQuality(coordinates),
          throwsA(isA<Exception>()));
    });

    // Test for temperature parsing in forecast
    test('Should correctly parse temperature from forecast', () async {
      final coordinates = await mockWeatherService.getCoordinates();
      final forecast = await mockWeatherService.dailyForecast(coordinates);
      expect(forecast.temperature, isA<double>());
      expect(forecast.temperature, equals(22.0));
    });

    // Test for temperature parsing in weather
    test('Should correctly parse temperature from weather data', () async {
      final weather = await mockWeatherService.getWeather({}, 'Test City');
      expect(weather.temperature, isA<double>());
      expect(weather.temperature, equals(20.0));
    });
  });
}
