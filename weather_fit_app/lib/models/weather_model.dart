class WeatherModel {
  final String location;
  final double temperature;
  final String weatherCondition;
  final String humidity;

  WeatherModel({
    required this.location,
    required this.temperature,
    required this.weatherCondition,
    required this.humidity
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      location: json['name'],
      temperature: json['main']['temp'].toDouble(),
      weatherCondition: json['weather'][0]['main'],
      humidity: json['main']['humidity'].toString()
    );
  }
}
