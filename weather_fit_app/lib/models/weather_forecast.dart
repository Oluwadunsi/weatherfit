class WeatherForecast{
  final String name;

  WeatherForecast({
    required this.name
  });

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    return WeatherForecast(
        name: json['name']
    );
  }
}
