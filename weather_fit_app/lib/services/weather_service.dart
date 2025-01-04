import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../models/weather_model.dart';
import '../models/weather_forecast.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  final String BASEURL = 'https://api.openweathermap.org/data/2.5/weather';
  final String apikey;

  WeatherService(this.apikey);

  Future<WeatherModel> getWeather(Map<String, double> coordinate, String cityName) async {
    try {
      String url = '';
      double? lat = coordinate["lat"];
      double? lon = coordinate["lon"];

      if (cityName.isEmpty) {
        url = '$BASEURL?lat=$lat&lon=$lon&appid=$apikey&units=metric';
      } else {
        url = '$BASEURL?q=$cityName&appid=$apikey&units=metric';
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['main'] != null && data['weather'] != null) {
          return WeatherModel.fromJson(data);
        } else {
          throw Exception('Invalid weather data structure');
        }
      } else {
        throw Exception('Failed to load weather data: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error in getWeather: $e');
      rethrow;
    }
  }

  Future<Map<String, double>> getCoordinates(String cityName) async {
    try {
      if (cityName.isNotEmpty) {
        final response = await http.get(Uri.parse('$BASEURL?q=$cityName&appid=$apikey&units=metric'));
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['coord'] != null) {
            return {"lat": data['coord']['lat'], "lon": data['coord']['lon']};
          } else {
            throw Exception('Invalid coordinates data structure');
          }
        } else {
          throw Exception('Failed to fetch coordinates: ${response.reasonPhrase}');
        }
      } else {
        return await _getCurrentLocation();
      }
    } catch (e) {
      print('Error in getCoordinates: $e');
      return {"lat": 0.0, "lon": 0.0}; // Return default values for fallback
    }
  }

  Future<Map<String, double>> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permission denied');
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      return {"lat": position.latitude, "lon": position.longitude};
    } catch (e) {
      print('Error in _getCurrentLocation: $e');
      throw Exception('Failed to fetch current location');
    }
  }

  Future<AirQuality> airQuality(Map<String, double> coordinate) async {
    try {
      double? lat = coordinate["lat"];
      double? lon = coordinate["lon"];
      final response = await http.get(
        Uri.parse('https://api.openweathermap.org/data/2.5/air_pollution/forecast?lat=$lat&lon=$lon&appid=$apikey&units=metric'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['list'] != null) {
          return AirQuality.fromJson(data);
        } else {
          throw Exception('Invalid air quality data structure');
        }
      } else {
        throw Exception('Failed to load air quality data: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error in airQuality: $e');
      rethrow;
    }
  }

  Future<WeatherForecast> dailyForecast(Map<String, double> coordinate) async {
    try {
      double? lat = coordinate["lat"];
      double? lon = coordinate["lon"];
      final response = await http.get(
        Uri.parse('https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$apikey&units=metric'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['list'] != null) {
          return WeatherForecast.fromJson(data);
        } else {
          throw Exception('Invalid forecast data structure');
        }
      } else {
        throw Exception('Failed to load forecast data: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error in dailyForecast: $e');
      rethrow;
    }
  }

/*
  Future<String> getCountryCode() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      const LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 100,
      );

      Position position = await Geolocator.getCurrentPosition(locationSettings: locationSettings);

      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);
      print(placemarks[0]);
      String? countryCode = placemarks[0].isoCountryCode;
      return countryCode ?? "";
    } catch (e) {
      // If there's any error (including null values), return empty string
      return "";
    }
  }

  Future<String> getPostalCode() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      const LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 100,
      );

      Position position = await Geolocator.getCurrentPosition(locationSettings: locationSettings);

      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);
      String? postalCode = placemarks[0].postalCode;
      return postalCode ?? "";
    } catch (e) {
      // If there's any error (including null values), return empty string
      return "";
    }
  } */
}