import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../models/weather_model.dart';
import '../models/weather_forecast.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  final String BASEURL = 'https://api.openweathermap.org/data/2.5/weather';
  final String apikey;

  WeatherService(this.apikey);

  Future<WeatherModel> getWeather(
      Map<String, double> coordinate, String cityName) async {
    String val = '';
    double? lat = coordinate["lat"];
    double? lon = coordinate["lon"];
    var url;
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
  }

  Future<void> getLocationPermission(
      {Future Function(Map<String, double>)? onLocationPermitted,
        VoidCallback? onLocationRejected}) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if ((permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) &&
        onLocationRejected != null) {
      onLocationRejected();
      return;
    }
    if ((permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) &&
        onLocationPermitted != null) {
      const LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 100,
      );

      Position position = await Geolocator.getCurrentPosition(
          locationSettings: locationSettings);
      var a = {"lat": position.latitude, "lon": position.longitude};
      await onLocationPermitted(a);
    }
  }

  Future<Map<String, double>?> getCoordinates(String cityName) async {
    if (cityName == "") return null;
    var uri = Uri.parse('$BASEURL?q=$cityName&appid=$apikey&units=metric');
    log("About to call -- ${uri.toString()}");
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      Map<String, dynamic> temp = jsonDecode(response.body);
      return {"lat": temp['coord']['lat'], "lon": temp['coord']['lon']};
    } else {
      throw Exception('Failed to load location coordinate');
    }
  }

  Future<AirQuality> airQuality(Map<String, double> coordinate) async {
    try {
      double? lat = coordinate["lat"];
      double? lon = coordinate["lon"];
      final response = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/air_pollution/forecast?lat=$lat&lon=$lon&appid=$apikey&units=metric'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['list'] != null) {
          return AirQuality.fromJson(data);
        } else {
          throw Exception('Invalid air quality data structure');
        }
      } else {
        throw Exception(
            'Failed to load air quality data: ${response.reasonPhrase}');
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
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$apikey&units=metric'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['list'] != null) {
          return WeatherForecast.fromJson(data);
        } else {
          throw Exception('Invalid forecast data structure');
        }
      } else {
        throw Exception(
            'Failed to load forecast data: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error in dailyForecast: $e');
      rethrow;
    }
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
