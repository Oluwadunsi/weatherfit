class WeatherModel {
  final String location;
  final double temperature;
  final String weatherCondition;
  final String humidity;
  final double feelsLikeTemperature;
  final double speed;
  final int pressure;
  final int visibility;

  WeatherModel({
    required this.location,
    required this.temperature,
    required this.weatherCondition,
    required this.humidity,
    required this.feelsLikeTemperature,
    required this.speed,
    required this.pressure,
    required this.visibility
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {

    return WeatherModel(
      location: json['name'],
      temperature: json['main']['temp'].toDouble(),
      weatherCondition: json['weather'][0]['main'],
      humidity: json['main']['humidity'].toString(),
      feelsLikeTemperature: json['main']['feels_like'].toDouble(),
      speed: json['wind']['speed'].toDouble(),
      pressure: json['main']['pressure'],
      visibility: json['visibility']
    );
  }
}

class AirQuality {
  final double airQualityIndex;

  AirQuality({
    required this.airQualityIndex
  });

  factory AirQuality.fromJson(Map<String, dynamic> json) {
    return AirQuality(
        airQualityIndex: json['list'][0]['main']['aqi'].toDouble()
    );
  }
}

/* class WeatherForecast{
  final String sevenDayForecast;

  WeatherForecast({
    required this.sevenDayForecast
  });

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    return WeatherForecast(
        sevenDayForecast: json['list'][0]['temp']['day'].toDouble()
    );
  }
} */
