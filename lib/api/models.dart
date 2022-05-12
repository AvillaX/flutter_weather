class Weather {
  Weather(
      {required this.city,
      required this.date,
      required this.weatherState,
      required this.weatherStateAbbr,
      required this.minTemp,
      required this.maxTemp,
      required this.currentTemp,
      required this.alldays,
      required this.humidity,
      required this.airPressure,
      required this.windSpeed});

  final String city;
  final String date;
  final String weatherState;
  final String weatherStateAbbr;
  final double minTemp;
  final double maxTemp;
  final double currentTemp;
  final double airPressure;
  final double windSpeed;
  final int humidity;
  final List<NextDays> alldays;

  factory Weather.fromJson(Map<String, dynamic> json) {
    final allDaysdata = json['consolidated_weather'] as List;
    return Weather(
      city: json['title'],
      date: json['consolidated_weather'][0]['applicable_date'],
      weatherState:
          json['consolidated_weather'][0]['weather_state_name'] as String,
      weatherStateAbbr:
          json['consolidated_weather'][0]['weather_state_abbr'] as String,
      minTemp: json['consolidated_weather'][0]['min_temp'] as double,
      maxTemp: json['consolidated_weather'][0]['max_temp'] as double,
      currentTemp: json['consolidated_weather'][0]['the_temp'] as double,
      humidity: json['consolidated_weather'][0]['humidity'] as int,
      airPressure: json['consolidated_weather'][0]['air_pressure'] as double,
      windSpeed: json['consolidated_weather'][0]['wind_speed'] as double,
      alldays: allDaysdata
          .map((e) => NextDays(
                weatherState: e['weather_state_abbr'] as String,
                date: e['applicable_date'] as String,
                maxTemp: e['max_temp'] as double,
                minTemp: e['min_temp'] as double,
              ))
          .toList(),
    );
  }
}

class NextDays {
  NextDays({
    required this.weatherState,
    required this.date,
    required this.maxTemp,
    required this.minTemp,
  });

  String weatherState;
  String date;
  double maxTemp;
  double minTemp;
}
