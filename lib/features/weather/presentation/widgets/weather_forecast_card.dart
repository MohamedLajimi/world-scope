import 'package:flutter/material.dart';
import 'package:worldscope/data/weather/models/weather_model.dart';
import 'package:worldscope/data/weather/utils/wmo_codes.dart';

class WeatherForecastCard extends StatelessWidget {
  const WeatherForecastCard({
    super.key,
    required this.day,
  });

  final DayForecast day;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                day.date,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                '${day.tempMax.round()}° / ${day.tempMin.round()}°',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              Text(
                wmoLabel(day.weatherCode),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF9FB2D7)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
