import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  final BASEURL = 'https://api.openweathermap.org/data/2.5/weather';
  final String apikey;

  WeatherService(this.apikey);

  Future<WeatherModel> getWeather(String postalCode, String countryCode, String cityName) async {
    String val = '';
    if (cityName == "") {
      val = '$BASEURL?zip=$postalCode,$countryCode&appid=$apikey&units=metric';
    } else {
      val = '$BASEURL?q=$cityName&appid=$apikey&units=metric';
    }
    print('city name: $cityName');
    final response = await http.get(Uri.parse(val));
    if (response.statusCode == 200) {
      print(response.body);
      return WeatherModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<WeatherModel> getSearchedWeather(String cityName) async {
    final response = await http.get(
      Uri.parse('$BASEURL?q=$cityName&appid=$apikey&units=metric'),
    );
    if (response.statusCode == 200) {
      print(response.body);
      return WeatherModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

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
  }
}
