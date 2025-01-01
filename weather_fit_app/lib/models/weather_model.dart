class WeatherModel {
  final String location;
  final double temperature;
  final String weatherCondition;
  final String humidity;
  final double feelsLikeTemperature;

  WeatherModel({
    required this.location,
    required this.temperature,
    required this.weatherCondition,
    required this.humidity,
    required this.feelsLikeTemperature
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {

    return WeatherModel(
      location: json['name'],
      temperature: json['main']['temp'].toDouble(),
      weatherCondition: json['weather'][0]['main'],
      humidity: json['main']['humidity'].toString(),
      feelsLikeTemperature: json['main']['feels_like'].toDouble(),
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
