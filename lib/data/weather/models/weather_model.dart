import 'package:intl/intl.dart';

class WeatherModel {
  const WeatherModel({
    required this.tempNow,
    required this.windSpeed,
    required this.weatherCode,
    required this.forecast,
  });

  final double tempNow;
  final double windSpeed;
  final int weatherCode;
  final List<DayForecast> forecast;

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final current = json['current'] as Map<String, dynamic>?;
    final daily = json['daily'] as Map<String, dynamic>?;

    final List<dynamic> times = (daily?['time'] as List<dynamic>?) ?? const [];
    final List<dynamic> minTemps =
        (daily?['temperature_2m_min'] as List<dynamic>?) ?? const [];
    final List<dynamic> maxTemps =
        (daily?['temperature_2m_max'] as List<dynamic>?) ?? const [];
    final List<dynamic> codes =
        (daily?['weather_code'] as List<dynamic>?) ?? const [];

    final int itemCount = [
      times.length,
      minTemps.length,
      maxTemps.length,
      codes.length,
    ].reduce((value, element) => value < element ? value : element);

    final forecast = List<DayForecast>.generate(itemCount, (index) {
      return DayForecast(
        date: _formatDateLabel(times[index] as String?),
        tempMin: (minTemps[index] as num?)?.toDouble() ?? 0,
        tempMax: (maxTemps[index] as num?)?.toDouble() ?? 0,
        weatherCode: (codes[index] as num?)?.toInt() ?? -1,
      );
    });

    return WeatherModel(
      tempNow: (current?['temperature_2m'] as num?)?.toDouble() ?? 0,
      windSpeed: (current?['wind_speed_10m'] as num?)?.toDouble() ?? 0,
      weatherCode: (current?['weather_code'] as num?)?.toInt() ?? -1,
      forecast: forecast,
    );
  }

  static String _formatDateLabel(String? dateRaw) {
    if (dateRaw == null || dateRaw.isEmpty) {
      return 'N/A';
    }

    try {
      final parsed = DateTime.parse(dateRaw);
      return DateFormat('EEE d').format(parsed);
    } catch (_) {
      return dateRaw;
    }
  }
}

class DayForecast {
  const DayForecast({
    required this.date,
    required this.tempMin,
    required this.tempMax,
    required this.weatherCode,
  });

  final String date;
  final double tempMin;
  final double tempMax;
  final int weatherCode;
}
