class WeatherForecast{
  final double temperature;
  final Map<String, dynamic> tempList;


  WeatherForecast({
    required this.temperature,
    required this.tempList
  });

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    return WeatherForecast(
      temperature: json['list'][4]['main']['temp'].toDouble(),
      tempList: json
    );
  }
}
